//
//  ContentView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import SwiftUI

struct ContentView: View {
    @State private var resultMessage: String = "Loading..."

    var body: some View {
        Text(resultMessage)
            .padding()
            .onAppear {
                fetchGitHubUserStats()
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
                    self.resultMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
