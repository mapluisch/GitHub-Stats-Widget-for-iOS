//
//  GitHubStatsLockscreenTimelineProvider.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 24.02.24.
//

import WidgetKit
import SwiftUI
import UserNotifications

struct GitHubStatsLockscreenTimelineProvider: IntentTimelineProvider {
    typealias Entry = GitHubUserStatsEntry
    typealias Intent = GitHubUserConfigurationIntent

    func placeholder(in context: Context) -> GitHubUserStatsEntry {
        GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 17, avatarImageData: nil, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0, contributions: sampleContributions(days: 365), lockscreenUsername: "mapluisch")
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.com.martinpluisch.githubstatswidget")
        let lockscreenUsername = userDefaults?.string(forKey: "lockscreenWidgetUsername") ?? configuration.username ?? ""
        completion(GitHubUserStatsEntry(date: Date(), username: lockscreenUsername, followers: 2, stars: 17, avatarImageData: nil, configuration: configuration, previousFollowers: 0, previousStars: 0, contributions: sampleContributions(days: 365), lockscreenUsername: lockscreenUsername))
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> Void) {
        let userDefaults = UserDefaults(suiteName: "group.com.martinpluisch.githubstatswidget")
        let lockscreenUsername = userDefaults?.string(forKey: "lockscreenWidgetUsername") ?? configuration.username ?? ""
        fetchAndUpdateStats(username: lockscreenUsername, configuration: configuration, completion: completion)
    }

    private func sampleContributions(days: Int) -> [Contribution] {
        (0..<days).map { day in
            Contribution(count: Int.random(in: 0...4), date: Calendar.current.date(byAdding: .day, value: -day, to: Date())!)
        }.reversed()
    }

    private func fetchAndUpdateStats(username: String, configuration: GitHubUserConfigurationIntent, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> Void) {
        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { statsResult in
            switch statsResult {
            case .success(let (user, totalStars)):
                ContributionFetcher().fetchContributions(username: username) { contributions in
                    URLSession.shared.dataTask(with: URL(string: user.avatar_url)!) { imageData, _, _ in
                        DispatchQueue.main.async {
                            let currentDate = Date()
                            let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
                            let previousValues = UserDefaults.getPreviousValues(forUsername: username)
                            let entry = GitHubUserStatsEntry(date: currentDate, username: username, followers: user.followers, stars: totalStars, avatarImageData: imageData, configuration: configuration, previousFollowers: previousValues.followers, previousStars: previousValues.stars, contributions: contributions, lockscreenUsername: username)
                            UserDefaults.updatePreviousValues(followers: user.followers, stars: totalStars, forUsername: username)
                            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
                        }
                    }.resume()
                }
            case .failure(let error):
                print("Error fetching GitHub stats: \(error)")
                fallbackTimeline(username: username, configuration: configuration, completion: completion)
            }
        }
    }

    private func fallbackTimeline(username: String, configuration: GitHubUserConfigurationIntent, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> Void) {
        let previousValues = UserDefaults.getPreviousValues(forUsername: username)
        let fallbackEntry = GitHubUserStatsEntry(date: Date(), username: username, followers: previousValues.followers, stars: previousValues.stars, avatarImageData: nil, configuration: configuration, previousFollowers: previousValues.followers, previousStars: previousValues.stars, contributions: [], lockscreenUsername: username)
        completion(Timeline(entries: [fallbackEntry], policy: .after(Date())))
    }
}

