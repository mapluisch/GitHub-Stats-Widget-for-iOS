//
//  SettingsView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 19.02.24.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("General")) {
                    HStack {
                        NavigationLink(destination: ThemeSelectionView()) {
                            Label("Theme", systemImage: "paintbrush")
                        }
                    }
                    Label("Rate", systemImage: "star.leadinghalf.fill")
                    Label("Feedback", systemImage: "envelope")
                }
                
                Section(header: Text("About")) {
                    Link(destination: URL(string: "https://github.com/mapluisch")!) {
                        Label("GitHub Repo", systemImage: "link")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
