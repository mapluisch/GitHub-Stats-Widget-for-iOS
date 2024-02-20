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
                    Link(destination: URL(string: "https://apps.apple.com/app/6477889134?action=write-review")!) {
                        Label("Rate", systemImage: "star.circle")
                    }
                    
                    let email = "hello@martinpluisch.com"
                    let subject = "GitHub Stats Widget Feedback"
                    let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        
                    Link(destination: URL(string: "mailto:\(email)?subject=\(encodedSubject)")!) {
                        Label("Feedback", systemImage: "envelope.circle")
                    }
                }
                
                Section(header: Text("About")) {
                    Link(destination: URL(string: "https://github.com/mapluisch/GitHub-Stats-Widget-for-iOS")!) {
                        Label("GitHub Repo", systemImage: "link.circle")
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}
