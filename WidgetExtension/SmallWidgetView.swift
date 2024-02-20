//
//  SmallWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct SmallWidgetView: View {
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        let linkColor = colorScheme == .dark ? Color.white : Color.black

        Link(destination: URL(string: "githubstatswidget://user/\(entry.configuration.username ?? "mapluisch")")!) {
            VStack(alignment: .center, spacing: 10) {
                UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
                StatsInfoView(entry: entry, colorScheme: colorScheme)
                if entry.configuration.showDate as? Bool ?? true {
                    DateInfoView()
                }
            }
        }.foregroundColor(linkColor)
    }
}
