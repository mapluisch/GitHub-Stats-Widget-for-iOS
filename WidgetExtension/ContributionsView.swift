//
//  ContributionsView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI

struct ContributionsView: View {
    var contributions: [Contribution]
    let numberOfDays: Int
    let maxCirclesPerRow: Int = 7

    var filteredContributions: [Contribution] {
        let sortedContributions = contributions.sorted { $0.date < $1.date }
    
        if sortedContributions.count > numberOfDays {
            return Array(sortedContributions.suffix(numberOfDays))
        } else {
            return sortedContributions
        }
    }
    
    var contributionsThisMonth: [Contribution] {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        guard let startOfMonth = calendar.date(from: components) else { return [] }
        
        return contributions.filter { $0.date >= startOfMonth && $0.date <= currentDate }
            .sorted(by: { $0.date < $1.date })
    }

    private var numberOfRows: Int {
        (contributions.count + maxCirclesPerRow - 1) / maxCirclesPerRow
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                HStack(spacing: 4) {
                    ForEach(0..<maxCirclesPerRow, id: \.self) { itemIndex in
                        let overallIndex = rowIndex * maxCirclesPerRow + itemIndex
                        if overallIndex < filteredContributions.count {
                            Circle()
                                .fill(colorForContribution(filteredContributions[overallIndex].count))
                                .strokeBorder(.white.opacity(0.4), lineWidth: (overallIndex == filteredContributions.count - 1) ? 2.5 : 0)
                                .frame(width: 12, height: 12)
                        } else {
                            Spacer()
                        }
                    }
                }
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
