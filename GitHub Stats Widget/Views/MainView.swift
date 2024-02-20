//
//  ContentView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import SwiftUI

struct MainView: View {
    @AppStorage("shouldRedirectToGitHub") var shouldRedirectToGitHub: Bool = false
    
    var body: some View {
        TabView {
            HowToView()
                .tabItem {
                    Label("How-To", systemImage: "book")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
        .onOpenURL { url in
            if shouldRedirectToGitHub,
               url.scheme == "githubstatswidget",
               let username = url.pathComponents.last {
                let userURL = URL(string: "https://github.com/\(username)")!
                UIApplication.shared.open(userURL)
            }
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
