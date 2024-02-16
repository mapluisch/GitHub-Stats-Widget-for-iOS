//
//  SmallWidgetWithContribsView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct SmallWidgetWithContribsView: View {
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
            StatsInfoView(entry: entry, colorScheme: colorScheme)
            Divider()
            ContributionsView(contributions: entry.contributions, numberOfDays: 7)
                .frame(height: 20)
                .offset(x: 0, y: 104)
            if entry.configuration.showDate as? Bool ?? true {
                DateInfoView()
                    .frame(height: 2)
                    .padding(0)
            }
        }
        .padding(0)
    }
}

