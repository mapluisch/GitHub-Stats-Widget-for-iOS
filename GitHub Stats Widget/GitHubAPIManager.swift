//
//  GitHubAPIManager.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 13.02.24.
//

import Foundation

struct GitHubUser: Codable {
    let login: String
    let followers: Int
}

struct Repository: Codable {
    let stargazers_count: Int
}

class GitHubAPIManager {
    static let shared = GitHubAPIManager()

    func fetchGitHubUserDetails(username: String, completion: @escaping (Result<GitHubUser, Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let user = try JSONDecoder().decode(GitHubUser.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchUserRepositories(username: String, completion: @escaping (Result<Int, Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)/repos"
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                let totalStars = repositories.reduce(0) { $0 + $1.stargazers_count }
                completion(.success(totalStars))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchGitHubUserStats(username: String, completion: @escaping (Result<(GitHubUser, Int), Error>) -> Void) {
        fetchGitHubUserDetails(username: username) { result in
            switch result {
            case .success(let user):
                self .fetchUserRepositories(username: username) { reposResult in
                    switch reposResult {
                    case .success(let totalStars):
                        completion(.success((user, totalStars)))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
