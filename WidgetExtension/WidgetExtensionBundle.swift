//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Martin Pluisch on 13.02.24.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        GitHubStatsWidget()
        GitHubStatsContributionWidget()
        if #available(iOS 16.0, *) {
            LockscreenWidget()
        }
    }
}
