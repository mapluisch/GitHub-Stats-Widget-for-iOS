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
}


struct GitHubStatsTimelineProvider: IntentTimelineProvider {
    typealias Entry = GitHubUserStatsEntry
    
    typealias Intent = GitHubUserConfigurationIntent
    
    func placeholder(in context: Context) -> GitHubUserStatsEntry {
        GitHubUserStatsEntry(date: Date(), username: "github", followers: 0, stars: 0, configuration: GitHubUserConfigurationIntent())
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> ()) {
        let entry = GitHubUserStatsEntry(date: Date(), username: "github", followers: 0, stars: 0, configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> ()) {
        // Use the GitHub username from the widget configuration
        let username = configuration.username ?? "github"

        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { result in
            var entries: [GitHubUserStatsEntry] = []
            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

            switch result {
            case .success(let (user, totalStars)):
                let entry = GitHubUserStatsEntry(date: currentDate, username: user.login, followers: user.followers, stars: totalStars, configuration: configuration)
                entries.append(entry)
            case .failure:
                let entry = GitHubUserStatsEntry(date: currentDate, username: username, followers: 0, stars: 0, configuration: configuration)
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .after(refreshDate))
            completion(timeline)
        }
    }
}

