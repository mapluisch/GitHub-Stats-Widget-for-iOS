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
        let linkColor = colorScheme == .dark ? Color.white : Color.black

        Link(destination: URL(string: "githubstatswidget://user/\(entry.configuration.username ?? "mapluisch")")!) {
            VStack(alignment: .center, spacing: 0) {
                UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, useProfilePicture: entry.configuration.useProfilePicture as? Bool ?? true, colorScheme: colorScheme, imageData: entry.avatarImageData,  miniatureImage: true)
                
                StatsInfoView(entry: entry, colorScheme: colorScheme)
                
                Divider()
                
                Spacer()
                
                ContributionsView(contributions: entry.contributions, numberOfDays: 7)
                
                Spacer()
                
                if entry.configuration.showDate as? Bool ?? true {
                    DateInfoView()
                }
            }
        }.foregroundColor(linkColor)
    }
}
