//
//  GitHubUserStatsEntry.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 24.02.24.
//

import WidgetKit

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
    let lockscreenUsername: String
}
