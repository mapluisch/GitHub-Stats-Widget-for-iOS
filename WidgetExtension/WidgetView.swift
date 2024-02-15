//
//  WidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import SwiftUI
import WidgetKit

// MARK: - GitHubStatsWidgetView

struct GitHubStatsWidgetView: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            userInfo
            statsInfo
            dateInfo
        }
        .containerBackground(Color(UIColor.systemBackground), for: .widget)
    }
    
    // MARK: - Subviews
    
    private var userInfo: some View {
        HStack {
            Image(colorScheme == .dark ? "github-light" : "github-dark")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(entry.username)
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(4)
                .frame(height: 24, alignment: .center)
                .contentTransition(.numericText())
        }
    }
    
    private var statsInfo: some View {
        HStack {
            Spacer()
            VStack {
                if entry.configuration.useIcons as? Bool ?? true {
                    iconAndText(for: "person.2", currentCount: entry.followers, previousCount: entry.previousFollowers)
                    iconAndText(for: "star.circle", currentCount: entry.stars, previousCount: entry.previousStars)
                 } else {
                     countText(prefix:"Followers: ", currentCount: entry.followers, previousCount: entry.previousFollowers)
                         .contentTransition(.numericText())
                     countText(prefix:"Stars: ", currentCount: entry.stars, previousCount: entry.previousStars)
                         .contentTransition(.numericText())
                }
            }
            .frame(maxWidth: entry.configuration.useIcons as? Bool ?? true ? 80 : .infinity)
            Spacer()
        }
    }

    private var dateInfo: some View {
        HStack {
            Image(colorScheme == .dark ? "github-light" : "github-dark")
                .renderingMode(.original)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(entry.username)
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(4)
                .frame(height: 24, alignment: .center)
                .contentTransition(.numericText())
        }
    }
    
    // MARK: - Helper Functions
    
    private func iconAndText(for type: String, currentCount: Int, previousCount: Int) -> some View {
        return HStack {
            Image(systemName: "\(type).fill")
                .scaledToFit()
                .frame(width: 16, height: 16)
            Spacer()
            countText(prefix: "", currentCount: currentCount, previousCount: previousCount)
                .baselineOffset(type == "star.circle" ? -2: 0)
        }
    }
    
    private func countText(prefix: String, currentCount: Int, previousCount: Int) -> Text {
        let formattedCount = currentCount.formatToK()
        let arrow = currentCount > previousCount ? "↑" : currentCount < previousCount ? "↓" : ""
        let arrowColor = currentCount > previousCount ? Color.green : Color.red
        
        if arrow.isEmpty {
            return Text("\(prefix)\(formattedCount)")
        } else {
            let combinedLabel = "\(prefix)\(formattedCount) "
            let combinedText = Text(combinedLabel) + Text(arrow).foregroundColor(arrowColor)
            return combinedText
        }
    }
}

extension Int {
    func formatToK() -> String {
        if self >= 1000 {
            let divided = Double(self) / 1000.0
            return String(format: "%.1fk", divided).replacingOccurrences(of: ".0", with: "")
        } else {
            return "\(self)"
        }
    }
}

// MARK: - Previews

struct GitHubStatsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubStatsWidgetView(entry: GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 2, stars: 15, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
