//
//  ContributionFetcher.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import Foundation

struct Contribution: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}

class ContributionFetcher : ObservableObject {
    @Published var lastWeekContributions: [Contribution] = []

    func fetchContributions(username: String, completion: @escaping ([Contribution]) -> Void) {
        let urlString = "https://github.com/users/\(username)/contributions"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion([])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                completion([])
                return
            }

            guard let htmlString = String(data: data, encoding: .utf8) else {
                print("Failed to convert data to string")
                completion([])
                return
            }

            let contributions = self.parseContributionsHTML(htmlString)
            completion(contributions)
        }
        task.resume()
    }

    func parseContributionsHTML(_ html: String) -> [Contribution] {
        var contributions: [Contribution] = []

        let lines = html.components(separatedBy: .newlines)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        for line in lines {
            if line.contains("data-date"),
               let datePart = line.slice(from: "data-date=\"", to: "\""),
               let date = dateFormatter.date(from: datePart),
               let levelPart = line.slice(from: "data-level=\"", to: "\""),
               let level = Int(levelPart) {
                    contributions.append(Contribution(count: level, date: date))
            }
        }

        return contributions
    }
    
    func updateLastWeekContributions(username: String) {
        fetchContributions(username: username) { contributions in
            let lastWeekDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            let sortedContributions = contributions.filter { $0.date >= lastWeekDate }.sorted(by: { $0.date < $1.date })
            
            DispatchQueue.main.async {
                self.lastWeekContributions = sortedContributions
            }
        }
    }
}
