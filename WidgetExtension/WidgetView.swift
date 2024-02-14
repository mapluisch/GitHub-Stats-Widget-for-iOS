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
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(colorScheme == .dark ? "github-white" : "github-black")
                    .renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                Text(entry.username)
                    .font(.headline)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text("Followers: \(entry.followers)")
                Text("Stars: \(entry.stars)")
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
