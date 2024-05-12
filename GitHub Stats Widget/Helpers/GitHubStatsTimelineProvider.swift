//
//  TimelineProvider.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import WidgetKit
import SwiftUI
import UserNotifications

struct GitHubStatsTimelineProvider: IntentTimelineProvider {
    typealias Entry = GitHubUserStatsEntry
    typealias Intent = GitHubUserConfigurationIntent

    func placeholder(in context: Context) -> GitHubUserStatsEntry {
        GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 3, stars: 20, avatarImageData: nil, configuration: GitHubUserConfigurationIntent(), previousFollowers: 0, previousStars: 0, contributions: sampleContributions(days: 365))
    }

    func getSnapshot(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (GitHubUserStatsEntry) -> Void) {
        completion(GitHubUserStatsEntry(date: Date(), username: "mapluisch", followers: 3, stars: 20, avatarImageData: nil, configuration: configuration, previousFollowers: 0, previousStars: 0, contributions: sampleContributions(days: 365)))
    }

    func getTimeline(for configuration: GitHubUserConfigurationIntent, in context: Context, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> Void) {
        let username = configuration.username ?? "mapluisch"
        fetchAndUpdateStats(username: username, configuration: configuration, completion: completion)
    }

    private func sampleContributions(days: Int) -> [Contribution] {
        (0..<days).map { day in
            Contribution(count: Int.random(in: 0...4), date: Calendar.current.date(byAdding: .day, value: -day, to: Date())!)
        }.reversed()
    }

    private func fetchAndUpdateStats(username: String, configuration: GitHubUserConfigurationIntent, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> Void) {
        GitHubAPIManager.shared.fetchGitHubUserStats(username: username) { statsResult in
            switch statsResult {
            case .success(let (user, repositories)):
                // fetch latest contributions
                ContributionFetcher().fetchContributions(username: username) { contributions in
                    URLSession.shared.dataTask(with: URL(string: user.avatar_url)!) { imageData, _, _ in
                        DispatchQueue.main.async {
                            // then, fetch and notify about changes in followers
                            GitHubAPIManager.shared.fetchFollowers(username: username) { followersResult in
                                switch followersResult {
                                case .success(let currentFollowers):
                                    let previousFollowers = UserDefaults.getFollowers(forUsername: username)
                                    if !previousFollowers.isEmpty {
                                        let newFollowers = currentFollowers.filter { !previousFollowers.contains($0) }
                                        newFollowers.forEach { follower in
                                            NotificationManager.scheduleNotification(title: "GitHub Stats - @\(username)", body: "\(follower) is now following \(username)")
                                        }
                                    }
                                    UserDefaults.setFollowers(followers: currentFollowers, forUsername: username)
                                case .failure(let error):
                                    print("Error fetching followers: \(error)")
                                }
                            }
                                
                            // finally, notify about changes in repo stars
                            let previousRepoStars = UserDefaults.getRepositoryStars(forUsername: username)
                            var currentRepoStars = [String: Int]()
                            let isFirstFetch = previousRepoStars.isEmpty

                            for repo in repositories {
                                let previousStars = previousRepoStars[repo.name] ?? 0
                                currentRepoStars[repo.name] = repo.stargazers_count

                                if repo.stargazers_count > previousStars && !isFirstFetch {
                                    let diff = repo.stargazers_count - previousStars
                                    NotificationManager.scheduleNotification(title: "GitHub Stats - @\(username)", body: "\(repo.name) gained \(diff) \(diff == 1 ? "star" : "stars")")
                                }
                            }

                            UserDefaults.setRepositoryStars(currentRepoStars, forUsername: username)

                            let currentDate = Date()
                            let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
                            let previousValues = UserDefaults.getPreviousValues(forUsername: username)
                            let totalStars = repositories.reduce(0) { $0 + $1.stargazers_count }

                            let entry = GitHubUserStatsEntry(
                                date: currentDate,
                                username: username,
                                followers: user.followers,
                                stars: totalStars,
                                avatarImageData: imageData,
                                configuration: configuration,
                                previousFollowers: previousValues.followers,
                                previousStars: previousValues.stars,
                                contributions: contributions
                            )
                            UserDefaults.updatePreviousValues(followers: user.followers, stars: totalStars, forUsername: username)
                            completion(Timeline(entries: [entry], policy: .after(refreshDate)))
                        }
                    }.resume()
                }
            case .failure(let error):
                print("Error fetching GitHub stats: \(error)")
                fallbackTimeline(username: username, configuration: configuration, completion: completion)
            }
        }
    }

    private func fallbackTimeline(username: String, configuration: GitHubUserConfigurationIntent, completion: @escaping (Timeline<GitHubUserStatsEntry>) -> Void) {
        let previousValues = UserDefaults.getPreviousValues(forUsername: username)
        let fallbackEntry = GitHubUserStatsEntry(date: Date(), username: username, followers: previousValues.followers, stars: previousValues.stars, avatarImageData: nil, configuration: configuration, previousFollowers: previousValues.followers, previousStars: previousValues.stars, contributions: [])
        completion(Timeline(entries: [fallbackEntry], policy: .after(Date())))
    }
}
