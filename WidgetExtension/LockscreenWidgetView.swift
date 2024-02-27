//
//  LockscreenWidgetView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 23.02.24.
//

import SwiftUI
import WidgetKit

struct LockscreenWidgetView: View {
    let entry: GitHubUserStatsEntry
    @Environment(\.widgetFamily) var widgetFamily
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        switch widgetFamily {
            case .accessoryRectangular:
                RectangularWidgetView(entry: entry, colorScheme: colorScheme)
                    .conditionalWidgetBackground(color: Color(UIColor.systemBackground), fallbackView: Group {})
            default:
                Text("Unsupported widget size")
        }
    }
}
