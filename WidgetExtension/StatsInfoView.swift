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
            Spacer()
            VStack {
                if entry.configuration.useIcons as? Bool ?? true {
                    IconAndTextView(type: "person.2", currentCount: entry.followers, previousCount: entry.previousFollowers)
                        .foregroundColor(.primary) // Apply any necessary styling here
                    Divider().padding(.top, -3)
                    IconAndTextView(type: "star.circle", currentCount: entry.stars, previousCount: entry.previousStars)
                        .foregroundColor(.primary)
                } else {
                    CountTextView(prefix: "Followers: ", currentCount: entry.followers, previousCount: entry.previousFollowers)
                    CountTextView(prefix: "Stars: ", currentCount: entry.stars, previousCount: entry.previousStars)
                }
            }
            .frame(maxWidth: entry.configuration.useIcons as? Bool ?? true ? 80 : .infinity)
            Spacer()
        }
    }
}
