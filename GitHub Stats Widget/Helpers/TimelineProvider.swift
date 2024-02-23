//
//  TimelineProvider.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import WidgetKit
import SwiftUI
import UserNotifications

struct GitHubUserStatsEntry: TimelineEntry {
    let date: Date
    let username: String
    let followers: Int
    let stars: Int
    let avatarImageData: Data?
    let configuration: GitHubUserConfigurationIntent
    let previousFollowers: Int
    let previousStars: Int
    let contributions: [Contribution]
}

struct UserDefaultsKeys {
    static func previousFollowersKey(forUsername username: String) -> String {
        "previousFollowers_\(username)"
    }
    static func previousStarsKey(forUsername username: String) -> String {
        "previousStars_\(username)"
    }
}

func updatePreviousValues(followers: Int, stars: Int, forUsername username: String) {
    let followersKey = UserDefaultsKeys.previousFollowersKey(forUsername: username)
    let starsKey = UserDefaultsKeys.previousStarsKey(forUsername: username)
    UserDefaults.standard.set(followers, forKey: followersKey)
    UserDefaults.standard.set(stars, forKey: starsKey)
}

func getPreviousValues(forUsername username: String) -> (followers: Int, stars: Int) {
    let followersKey = UserDefaultsKeys.previousFollowersKey(forUsername: username)
    let starsKey = UserDefaultsKeys.previousStarsKey(forUsername: username)
    let followers = UserDefaults.standard.integer(forKey: followersKey)
    let stars = UserDefaults.standard.integer(forKey: starsKey)
    return (followers, stars)
}

func scheduleNotification(title: String, body: String) {
    DispatchQueue.main.async {
        let notifyOnStatsChange = UserDefaults.standard.bool(forKey: "notifyOnStatsChange")
        if !notifyOnStatsChange {
            return
        }
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
}

struct GitHubStatsTimelineProvider: IntentTimelineProvider {
    typealias Entry = GitHubUserStatsEntry
    typealias Intent = GitHubUserConfigurationIntent
    
    func placeholder(in context: Context) -> GitHubUserStatsEntry {
        let sampleDays = 365
        let sampleContributions: [Contribution] = (0..<sampleDays).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            let count = Int.random(in: 0...4)
            return Contribution(count: count, date: date)
        }.reversed()
        return GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 17, avatarImageData: nil, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0, contributions: sampleContributions)
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> ()) {
        let sampleDays = 365
        let sampleContributions: [Contribution] = (0..<sampleDays).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            let count = Int.random(in: 0...4)
            return Contribution(count: count, date: date)
        }.reversed()
        let entry = GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 17, avatarImageData: nil, configuration: configuration, previousFollowers: 0, previousStars: 0, contributions: sampleContributions)
        completion(entry)
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> ()) {
        let username = configuration.username ?? "mapluisch"

        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { statsResult in
            switch statsResult {
                case .success(let (user, totalStars)):
                    ContributionFetcher().fetchContributions(username: username) { contributions in
                        let avatarURL = URL(string: user.avatar_url)!
                        URLSession.shared.dataTask(with: avatarURL) { imageData, response, error in
                            guard let imageData = imageData, error == nil else {
                                print("Failed to download avatar image")
                                return
                            }
                            
                            DispatchQueue.main.async {
                                let currentDate = Date()
                                let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                                
                                let previousValues = getPreviousValues(forUsername: username)
                                
                                if user.followers > previousValues.followers {
                                    scheduleNotification(title: "GitHub Stats - @\(username)" , body: "You've gained a new GitHub follower!")
                                }
                                
                                if totalStars > previousValues.stars {
                                    scheduleNotification(title: "GitHub Stats - @\(username)", body: "One of your GitHub repos got starred!")
                                }
                                
                                let entry = GitHubUserStatsEntry(
                                    date: currentDate,
                                    username: username,
                                    followers: user.followers,
                                    stars: totalStars,
                                    avatarImageData: imageData,
                                    configuration: configuration,
                                    previousFollowers: previousValues.followers,
                                    previousStars: previousValues.stars,
                                    contributions: contributions
                                )
                                
                                updatePreviousValues(followers: user.followers, stars: totalStars, forUsername: username)
                                
                                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                                completion(timeline)
                            }
                        }.resume()
                    }
                case .failure(let error):
                    print("Error fetching GitHub stats: \(error)")

                    let previousValues = getPreviousValues(forUsername: username)

                    let fallbackEntry = GitHubUserStatsEntry(date: Date(), username: username, followers: previousValues.followers, stars: previousValues.stars, avatarImageData: nil, configuration: configuration, previousFollowers: previousValues.followers, previousStars: previousValues.stars, contributions: [])
                    let timeline = Timeline(entries: [fallbackEntry], policy: .after(Date()))
                    completion(timeline)
                }
        }
    }
}
