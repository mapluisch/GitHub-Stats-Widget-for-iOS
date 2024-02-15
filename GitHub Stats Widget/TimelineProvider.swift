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

struct GitHubStatsTimelineProvider: IntentTimelineProvider {
    typealias Entry = GitHubUserStatsEntry
    typealias Intent = GitHubUserConfigurationIntent
    
    func placeholder(in context: Context) -> GitHubUserStatsEntry {
        GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0, contributions: [])
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> ()) {
        let entry = GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: configuration, previousFollowers: 0, previousStars: 0, contributions: [])
        completion(entry)
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> ()) {
        let username = configuration.username ?? "mapluisch"
        
        ContributionFetcher().fetchContributions(username: username) { contributions in
            let currentDate = Date()
            var entries: [GitHubUserStatsEntry] = []
            
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let entry = GitHubUserStatsEntry(date: currentDate, username: username, followers: 2, stars: 15, configuration: configuration, previousFollowers: 0, previousStars: 0, contributions: contributions)
            entries.append(entry)
            
            let timeline = Timeline(entries: entries, policy: .after(refreshDate))
            completion(timeline)
        }
    }
}
