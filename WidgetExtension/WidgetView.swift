//
//  WidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import SwiftUI
import WidgetKit

// MARK: - GitHubStatsWidgetView

struct GitHubStatsWidgetView: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            if widgetFamily == .systemSmall {
                SmallWidgetView(entry: entry, colorScheme: colorScheme)
                    .containerBackground(Color(UIColor.systemBackground), for: .widget)
            } else if widgetFamily == .systemMedium {
                MediumWidgetView(entry: entry, colorScheme: colorScheme)
                    .containerBackground(Color(UIColor.systemBackground), for: .widget)
            } else if widgetFamily == .systemLarge {
                LargeWidgetView(entry: entry, colorScheme: colorScheme)
                    .containerBackground(Color(UIColor.systemBackground), for: .widget)
            } else {
                SmallWidgetView(entry: entry, colorScheme: colorScheme)
                    .containerBackground(Color(UIColor.systemBackground), for: .widget)
            }
        }
    }
}
    
// MARK: - Previews

struct GitHubStatsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GitHubStatsWidgetView(
                entry: GitHubUserStatsEntry(
                    date: Date(),
                    username: "mapluisch",
                    followers: 2,
                    stars: 15,
                    configuration: GitHubUserConfigurationIntent(),
                    previousFollowers: 0,
                    previousStars: 0
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small Widget")
            
            GitHubStatsWidgetView(
                entry: GitHubUserStatsEntry(
                    date: Date(),
                    username: "mapluisch",
                    followers: 2,
                    stars: 15,
                    configuration: GitHubUserConfigurationIntent(),
                    previousFollowers: 0,
                    previousStars: 0
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemMedium))
            .previewDisplayName("Medium Widget")
            
            GitHubStatsWidgetView(
                entry: GitHubUserStatsEntry(
                    date: Date(),
                    username: "mapluisch",
                    followers: 2,
                    stars: 15,
                    configuration: GitHubUserConfigurationIntent(),
                    previousFollowers: 0,
                    previousStars: 0
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large Widget")
        }
    }
}
