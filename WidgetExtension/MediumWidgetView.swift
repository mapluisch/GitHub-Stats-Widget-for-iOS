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
            Spacer()
            VStack(alignment: .center, spacing: 16) {
                UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
                StatsInfoView(entry: entry, colorScheme: colorScheme)
                if entry.configuration.showDate as? Bool ?? true {
                    DateInfoView()
                }
            }.padding()
            Divider()
            VStack(alignment: .center, spacing: 16) {
                Text("Contributions")
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .frame(height: 20, alignment: .center)
                ContributionsView(contributions: entry.contributions, numberOfDays: 28)
            }.padding()
            Spacer()
        }
    }
}
