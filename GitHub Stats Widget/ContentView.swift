//
//  ContentView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Overview", systemImage: "chart.bar.xaxis")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }.onOpenURL { url in
            print("Opened URL: \(url)")
        }
    }
}

struct ContentView: View {
    @State private var resultMessage: String = "Loading..."

    var body: some View {
        VStack {
            Spacer()
            Text(resultMessage)
                .padding()
                .onAppear {
                    fetchGitHubUserStats()
                }
            Spacer()
        }
    }
    
    private func fetchGitHubUserStats() {
        let username = "mapluisch"
        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let (user, totalStars)):
                    self.resultMessage = "Followers: \(user.followers), Total Stars: \(totalStars)"
                case .failure(let error):
                    self.resultMessage = "\(error.localizedDescription)"
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
