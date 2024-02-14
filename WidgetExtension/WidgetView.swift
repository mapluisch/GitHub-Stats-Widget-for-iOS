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
        }
        .containerBackground(Color(UIColor.systemBackground), for: .widget)
    }
    
    // MARK: - Subviews
    
    private var userInfo: some View {
        HStack {
            iconImage(named: colorScheme == .dark ? "github-light" : "github-dark", width: 24, height: 24)
            Text(entry.username)
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(4)
                .frame(height: 24, alignment: .center)
        }
    }
    
    private var statsInfo: some View {
        HStack {
            Spacer()
            VStack {
                if entry.configuration.useIcons as? Bool ?? true {
                    iconAndText(for: "followers", currentCount: entry.followers, previousCount: entry.previousFollowers)
                    iconAndText(for: "star", currentCount: entry.stars, previousCount: entry.previousStars)
                 } else {
                     countText(prefix:"Followers: ", currentCount: entry.followers, previousCount: entry.previousFollowers)
                     countText(prefix:"Stars: ", currentCount: entry.stars, previousCount: entry.previousStars)
                }
            }
            .frame(maxWidth: entry.configuration.useIcons as? Bool ?? true ? 85 : .infinity)
            Spacer()
        }
    }

    
    // MARK: - Helper Functions
    
    private func iconAndText(for type: String, currentCount: Int, previousCount: Int) -> some View {
        let iconName = "\(type)-\(colorScheme == .dark ? "light" : "dark")"
        return HStack {
            iconImage(named: iconName, width: 16, height: 16)
            Spacer()
            countText(prefix: "", currentCount: currentCount, previousCount: previousCount)
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
    
    private func iconImage(named name: String, width: CGFloat, height: CGFloat) -> some View {
        Image(name)
            .renderingMode(.original)
            .resizable()
            .scaledToFit()
            .frame(width: width, height: height)
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
