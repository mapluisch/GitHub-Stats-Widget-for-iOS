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

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: "person.fill") // Placeholder for GitHub icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(entry.username)
                    .font(.headline)
            }
            Text("Followers: \(entry.followers)")
            Text("Stars: \(entry.stars)")
        }
        .padding()
    }
}
