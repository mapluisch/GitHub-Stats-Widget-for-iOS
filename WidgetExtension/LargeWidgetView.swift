//
//  LargeWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    
    // to be implemented
    // right now it's just a copy of the small widget
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
            StatsInfoView(entry: entry, colorScheme: colorScheme)
            if entry.configuration.showDate as? Bool ?? true {
                DateInfoView()
            }
        }
        .padding()
    }
}

