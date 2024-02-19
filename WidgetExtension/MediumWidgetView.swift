//
//  MediumWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct MediumWidgetView: View {
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        HStack {
            
            VStack(alignment: .center, spacing: 16) {
                UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
                StatsInfoView(entry: entry, colorScheme: colorScheme)
                if entry.configuration.showDate as? Bool ?? true {
                    DateInfoView()
                }
            }
            .frame(maxWidth: .infinity)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                ContributionsView(contributions: entry.contributions, numberOfDays: 49)
            }
            .frame(maxWidth: .infinity)
            
        }
        
    }
}
