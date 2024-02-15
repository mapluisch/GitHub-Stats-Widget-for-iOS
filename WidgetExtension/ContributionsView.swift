//
//  ContributionsView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI

struct ContributionsView: View {
    let contributions: [Contribution]
    let numberOfDays: Int

    var filteredContributions: [Contribution] {
            let sortedContributions = contributions.sorted { $0.date < $1.date }
        
            if sortedContributions.count > numberOfDays {
                return Array(sortedContributions.suffix(numberOfDays))
            } else {
                return sortedContributions
            }
        }

    var body: some View {
        HStack {
            ForEach(filteredContributions, id: \.date) { contribution in
                Circle()
                    .fill(colorForContribution(contribution.count))
                    .frame(width: 12, height: 12)
            }
        }
    }

    private func colorForContribution(_ count: Int) -> Color {
        let baseColor = Color.blue
        switch count {
        case 0:
            // no contribs
            return Color.gray.opacity(0.1)
        case 1:
            // low contribs
            return baseColor.opacity(0.25)
        case 2:
            // medium contribs
            return baseColor.opacity(0.5)
        case 3:
            // med-high contribs
            return baseColor.opacity(0.75)
        case 4:
            // high contribs
            return baseColor
        default:
            return Color.gray.opacity(0.1)
        }
    }
}
