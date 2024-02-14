//
//  WidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import SwiftUI
import WidgetKit

struct GitHubStatsWidgetView: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
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
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(alignment: .leading, spacing: 6) {
                if entry.configuration.useIcons as? Bool ?? false {
                    HStack {
                        Image(colorScheme == .dark ? "followers-light" : "followers-dark")
                            .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        Text("\(entry.followers)")
                    }
                    HStack {
                        Image(colorScheme == .dark ? "star-light" : "star-dark")
                            .renderingMode(.original)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                        Text("\(entry.stars)")
                    }
                } else {
                    Text("Followers: \(entry.followers)")
                    Text("Stars: \(entry.stars)")
                }
            }
        }
        .containerBackground(Color(UIColor.systemBackground), for: .widget)
    }
}


struct GitHubStatsWidgetView_Previews: PreviewProvider {
    static var previews: some View {
        GitHubStatsWidgetView(entry: GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 0, stars: 0, configuration: GitHubUserConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
