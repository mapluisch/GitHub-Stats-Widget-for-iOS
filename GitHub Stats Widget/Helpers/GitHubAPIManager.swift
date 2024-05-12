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
    let avatar_url: String
}

struct Repository: Codable {
    let name: String
    let stargazers_count: Int
}

struct GitHubFollower: Codable {
    let login: String
    let id: Int
    let avatar_url: String
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
    
    func fetchFollowers(username: String, completion: @escaping (Result<[String], Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)/followers"
        guard let url = URL(string: urlString) else { return completion(.failure(URLError(.badURL))) }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return completion(.failure(URLError(.cannotParseResponse))) }

            do {
                let followersArray = try JSONDecoder().decode([GitHubFollower].self, from: data)
                let followers = followersArray.map { $0.login }
                completion(.success(followers))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchUserRepositories(username: String, completion: @escaping (Result<[Repository], Error>) -> Void) {
        let urlString = "https://api.github.com/users/\(username)/repos"
        guard let url = URL(string: urlString) else { return completion(.failure(URLError(.badURL))) }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return completion(.failure(URLError(.cannotParseResponse))) }

            do {
                let repositories = try JSONDecoder().decode([Repository].self, from: data)
                completion(.success(repositories))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func fetchGitHubUserStats(username: String, completion: @escaping (Result<(GitHubUser, [Repository]), Error>) -> Void) {
        fetchGitHubUserDetails(username: username) { userDetailsResult in
            switch userDetailsResult {
            case .success(let user):
                self.fetchUserRepositories(username: username) { reposResult in
                    switch reposResult {
                    case .success(let repositories):
                        completion(.success((user, repositories)))
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
