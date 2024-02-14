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
        VStack(alignment: .leading, spacing: 16) {
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
        VStack {
            if entry.configuration.useIcons as? Bool ?? true {
                iconAndText(for: "followers", count: entry.followers)
                iconAndText(for: "star", count: entry.stars)
            } else {
                Text("Followers: \(entry.followers)")
                Text("Stars: \(entry.stars)")
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func iconAndText(for type: String, count: Int) -> some View {
        let iconName = "\(type)-\(colorScheme == .dark ? "light" : "dark")"
        return HStack {
            iconImage(named: iconName, width: 20, height: 20)
            Text("\(count)")
                .minimumScaleFactor(0.5)
                .lineLimit(1)
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

// MARK: - Previews

struct GitHubStatsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubStatsWidgetView(entry: GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 12, stars: 34, configuration: GitHubUserConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
