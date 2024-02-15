//
//  WidgetExtension.swift
//  WidgetExtension
//
//  Created by Martin Pluisch on 13.02.24.
//

import WidgetKit
import SwiftUI

struct GitHubStatsWidget: Widget {
    let kind: String = "GitHubStatsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: GitHubUserConfigurationIntent.self, provider: GitHubStatsTimelineProvider()) { entry in
            GitHubStatsWidgetView(entry: entry)
        }
        .configurationDisplayName("GitHub Stats")
        .description("Displays GitHub followers and stars.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct GitHubStatsWidget2: Widget {
    let kind: String = "GitHubStatsWidget2"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: GitHubUserConfigurationIntent.self, provider: GitHubStatsTimelineProvider()) { entry in
            GitHubStatsWidget2View(entry: entry)
        }
        .configurationDisplayName("GitHub Stats")
        .description("Displays GitHub followers and stars.")
        .supportedFamilies([.systemSmall])
    }
}
