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
        VStack(alignment: .center, spacing: 16) {
            UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
            StatsInfoView(entry: entry, colorScheme: colorScheme)
            Divider()
            ContributionsView(contributions: entry.contributions, numberOfDays: 28)
                .scaleEffect(0.85)
                .offset(x: 0, y: -4)
        }
        .padding()
    }
}

