//
//  StatsInfoView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct StatsInfoView: View {
    var entry: GitHubUserStatsEntry
    var colorScheme: ColorScheme

    var body: some View {
        HStack {
            VStack {
                if entry.configuration.useIcons as? Bool ?? true {
                    Spacer()
                    IconAndTextView(type: "person.2", currentCount: entry.followers, previousCount: entry.previousFollowers)
                        .foregroundColor(.primary)
                    Spacer()
                    Divider()
                    Spacer()
                    IconAndTextView(type: "star.circle", currentCount: entry.stars, previousCount: entry.previousStars)
                        .foregroundColor(.primary)
                    Spacer()
                } else {
                    Spacer()
                    CountTextView(prefix: "Followers: ", currentCount: entry.followers, previousCount: entry.previousFollowers)
                    Spacer()
                    CountTextView(prefix: "Stars: ", currentCount: entry.stars, previousCount: entry.previousStars)
                    Spacer()
                }
            }
            .frame(maxWidth: entry.configuration.useIcons as? Bool ?? true ? 100 : .infinity)
        }
    }
}
