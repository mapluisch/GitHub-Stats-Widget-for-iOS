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

struct GitHubStatsContributionWidget: Widget {
    let kind: String = "ContributionsWidgetView"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: GitHubUserConfigurationIntent.self, provider: GitHubStatsTimelineProvider()) { entry in
            ContributionsWidgetView(entry: entry)
        }
        .configurationDisplayName("GitHub Stats")
        .description("Displays GitHub followers and stars with this weeks contributions.")
        .supportedFamilies([.systemSmall])
    }
}

@available(iOSApplicationExtension 16.0, *)
struct LockscreenWidget: Widget {
    let kind: String = "LockscreenWidgetView"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: GitHubUserConfigurationIntent.self, provider: GitHubStatsLockscreenTimelineProvider()) { entry in
            LockscreenWidgetView(entry: entry)
        }
        .configurationDisplayName("GitHub Stats")
        .description("Displays GitHub followers and stars (setup via the Settings tab in the app).")
        .supportedFamilies([.accessoryRectangular])
    }
}
