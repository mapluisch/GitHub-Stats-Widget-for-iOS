//
//  LockscreenWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 23.02.24.
//

import SwiftUI
import WidgetKit

struct LockscreenWidgetView: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        switch widgetFamily {
            case .accessoryRectangular:
                RectangularWidgetView(entry: entry, colorScheme: colorScheme)
                    .conditionalWidgetBackground(color: Color(UIColor.systemBackground), fallbackView: Group {})
            default:
                Text("Unsupported widget size")
        }
    }
}

struct RectangularWidgetView: View {
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        let linkColor = colorScheme == .dark ? Color.white : Color.black
        HStack {
            Image(colorScheme == .dark ? "github-light" : "github-dark")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Divider()
            VStack {
                Link(destination: URL(string: "githubstatswidget://user/\(entry.configuration.username ?? "mapluisch")")!) {
                    VStack(alignment: .center, spacing: 2) {
                        StatsInfoView(entry: entry, colorScheme: colorScheme)
                    }
                }.foregroundColor(linkColor)
            }
        }
    }
}
