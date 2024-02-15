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
            if entry.configuration.showDate as? Bool ?? true {
                dateInfo
            }
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
            let nameString = (entry.configuration.showUsername as? Bool ?? true) ? entry.username : "GitHub Stats"
            Text(nameString)
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
                    iconAndText(for: "person.2", currentCount: entry.followers, previousCount: entry.previousFollowers)
                    iconAndText(for: "star.circle", currentCount: entry.stars, previousCount: entry.previousStars)
                 } else {
                     countText(prefix:"Followers: ", currentCount: entry.followers, previousCount: entry.previousFollowers)
                     countText(prefix:"Stars: ", currentCount: entry.stars, previousCount: entry.previousStars)
                }
            }
            .frame(maxWidth: entry.configuration.useIcons as? Bool ?? true ? 80 : .infinity)
            Spacer()
        }
    }

    private var dateInfo: some View {
        HStack {
            Text(currentDateTimeString())
                .font(.system(size: 14, weight: .light))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }

    
    // MARK: - Helper Functions
    
    private func currentDateTimeString() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: now)
    }
    
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
