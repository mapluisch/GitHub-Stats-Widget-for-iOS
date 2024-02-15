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

struct GitHubStatsWidget2View: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            SmallWidgetWithContribsView(entry: entry, colorScheme:   colorScheme)
                .containerBackground(Color(UIColor.systemBackground), for: .widget)
        }
    }
}


    
// MARK: - Previews
let sampleContributions = [
    Contribution(date: Calendar.current.date(byAdding: .day, value: -8, to: Date())!, count: 0),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -7, to: Date())!, count: 0),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -6, to: Date())!, count: 0),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -5, to: Date())!, count: 0),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, count: 0),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, count: 1),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, count: 2),
    Contribution(date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, count: 3),
    Contribution(date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, count: 4)
]

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
                    previousStars: 0,
                    contributions: sampleContributions
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small Widget")
            
            GitHubStatsWidget2View(
                entry: GitHubUserStatsEntry(
                    date: Date(),
                    username: "mapluisch",
                    followers: 2,
                    stars: 15,
                    configuration: GitHubUserConfigurationIntent(),
                    previousFollowers: 0,
                    previousStars: 0,
                    contributions: sampleContributions
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemSmall))
            .previewDisplayName("Small Widget With Contribs")
            
            GitHubStatsWidgetView(
                entry: GitHubUserStatsEntry(
                    date: Date(),
                    username: "mapluisch",
                    followers: 2,
                    stars: 15,
                    configuration: GitHubUserConfigurationIntent(),
                    previousFollowers: 0,
                    previousStars: 0,
                    contributions: sampleContributions
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
                    previousStars: 0,
                    contributions: sampleContributions
                )
            )
            .previewContext(WidgetPreviewContext(family: .systemLarge))
            .previewDisplayName("Large Widget")
        }
    }
}
