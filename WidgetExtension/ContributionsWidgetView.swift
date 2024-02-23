//
//  ContributionsWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 19.02.24.
//

import SwiftUI

struct ContributionsWidgetView: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        Group {
            SmallWidgetWithContribsView(entry: entry, colorScheme: colorScheme)
        }
        .conditionalWidgetBackground(color: Color(UIColor.systemBackground), fallbackView: Group {})
    }
}
