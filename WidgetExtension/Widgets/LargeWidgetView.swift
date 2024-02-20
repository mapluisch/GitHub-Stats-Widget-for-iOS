//
//  LargeWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct LargeWidgetView: View {
    
    let entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        let linkColor = colorScheme == .dark ? Color.white : Color.black

        Link(destination: URL(string: "githubstatswidget://user/\(entry.configuration.username ?? "mapluisch")")!) {
            VStack(alignment: .center, spacing: 16) {
                UserInfoView(username: entry.configuration.username ?? "mapluisch", showUsername: entry.configuration.showUsername as? Bool ?? true, colorScheme: colorScheme)
                
                HStack {
                    
                    StatsInfoView(entry: entry, colorScheme: colorScheme)
                        .frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    UserAvatarView(imageData: entry.avatarImageData)
                        .frame(maxWidth: .infinity)
                }
                
                
                Divider()
                
                ContributionsView(contributions: entry.contributions, numberOfDays: 7*18)
                
                if entry.configuration.showDate as? Bool ?? true {
                    Divider()
                    
                    DateInfoView()
                }
            }
            .padding()
        }.foregroundColor(linkColor)
    }
}
