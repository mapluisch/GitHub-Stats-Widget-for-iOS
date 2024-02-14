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
        let username = configuration.username ?? "mapluisch"
        
        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { result in
            let currentDate = Date()
            let refreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!
            let defaults = UserDefaults.standard
            
            let previousFollowers = defaults.integer(forKey: "\(username)_followers")
            let previousStars = defaults.integer(forKey: "\(username)_stars")
            
            switch result {
            case .success(let (user, totalStars)):
                defaults.set(user.followers, forKey: "\(username)_followers")
                defaults.set(totalStars, forKey: "\(username)_stars")
                
                let entry = GitHubUserStatsEntry(date: currentDate, username: user.login, followers: user.followers, stars: totalStars, configuration: configuration, previousFollowers: previousFollowers, previousStars: previousStars)
                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            case .failure:
                let entry = GitHubUserStatsEntry(date: currentDate, username: username, followers: 0, stars: 0, configuration: configuration, previousFollowers: previousFollowers, previousStars: previousStars)
                completion(Timeline(entries: [entry], policy: .after(refreshDate)))
            }
        }
    }
}

