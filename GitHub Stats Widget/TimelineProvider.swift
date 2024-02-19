//
//  TimelineProvider.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import WidgetKit
import SwiftUI

struct GitHubUserStatsEntry: TimelineEntry {
    let date: Date
    let username: String
    let followers: Int
    let stars: Int
    let configuration: GitHubUserConfigurationIntent
    let previousFollowers: Int
    let previousStars: Int
    let contributions: [Contribution]
}

struct UserDefaultsKeys {
    static let previousFollowers = "previousFollowers"
    static let previousStars = "previousStars"
}

func updatePreviousValues(followers: Int, stars: Int) {
    UserDefaults.standard.set(followers, forKey: UserDefaultsKeys.previousFollowers)
    UserDefaults.standard.set(stars, forKey: UserDefaultsKeys.previousStars)
}

func getPreviousValues() -> (followers: Int, stars: Int) {
    let followers = UserDefaults.standard.integer(forKey: UserDefaultsKeys.previousFollowers)
    let stars = UserDefaults.standard.integer(forKey: UserDefaultsKeys.previousStars)
    return (followers, stars)
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
        return GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0, contributions: sampleContributions)
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> ()) {
        let sampleDays = 365
        let sampleContributions: [Contribution] = (0..<sampleDays).map { day in
            let date = Calendar.current.date(byAdding: .day, value: -day, to: Date())!
            let count = Int.random(in: 0...4)
            return Contribution(count: count, date: date)
        }.reversed()
        let entry = GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: configuration, previousFollowers: 0, previousStars: 0, contributions: sampleContributions)
        completion(entry)
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> ()) {
        let username = configuration.username ?? "mapluisch"

        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { statsResult in
            switch statsResult {
            case .success(let (user, totalStars)):
                ContributionFetcher().fetchContributions(username: username) { contributions in
                    let currentDate = Date()
                    let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
                    
                    let previousValues = getPreviousValues()
                    
                    let entry = GitHubUserStatsEntry(date: currentDate, username: username, followers: user.followers, stars: totalStars, configuration: configuration, previousFollowers: previousValues.followers, previousStars: previousValues.stars, contributions: contributions)
                    
                    updatePreviousValues(followers: user.followers, stars: totalStars)
                    
                    let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                    completion(timeline)
                }
            case .failure(let error):
                print("Error fetching GitHub stats: \(error)")

                let previousValues = getPreviousValues()

                let fallbackEntry = GitHubUserStatsEntry(date: Date(), username: username, followers: previousValues.followers, stars: previousValues.stars, configuration: configuration, previousFollowers: previousValues.followers, previousStars: previousValues.stars, contributions: [])
                let timeline = Timeline(entries: [fallbackEntry], policy: .after(Date()))
                completion(timeline)
            }
        }
    }
}
