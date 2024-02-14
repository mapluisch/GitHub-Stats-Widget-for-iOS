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
}


struct GitHubStatsTimelineProvider: IntentTimelineProvider {
    typealias Entry = GitHubUserStatsEntry
    
    typealias Intent = GitHubUserConfigurationIntent
    
    func placeholder(in context: Context) -> GitHubUserStatsEntry {
        GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0)
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> ()) {
        let entry = GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: configuration, previousFollowers: 0, previousStars: 0)
        completion(entry)
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> ()) {
        let username = configuration.username ?? "defaultUsername"
        
        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { result in
            var entries: [GitHubUserStatsEntry] = []
            let currentDate = Date()
            
            let refreshInterval = 5
            let totalRefreshIntervals = 12
            
            for i in 0..<totalRefreshIntervals {
                if let entryDate = Calendar.current.date(byAdding: .minute, value: i * refreshInterval, to: currentDate) {
                    let previousFollowers = UserDefaults.standard.integer(forKey: "\(username)_followers")
                    let previousStars = UserDefaults.standard.integer(forKey: "\(username)_stars")
                    
                    var followers = previousFollowers
                    var stars = previousStars
                    
                    if case .success(let (user, totalStars)) = result {
                        followers = user.followers
                        stars = totalStars
                        
                        UserDefaults.standard.set(followers, forKey: "\(username)_followers")
                        UserDefaults.standard.set(stars, forKey: "\(username)_stars")
                    }
                    
                    let entry = GitHubUserStatsEntry(date: entryDate, username: username, followers: followers, stars: stars, configuration: configuration, previousFollowers: previousFollowers, previousStars: previousStars)
                    entries.append(entry)
                }
            }
            
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

