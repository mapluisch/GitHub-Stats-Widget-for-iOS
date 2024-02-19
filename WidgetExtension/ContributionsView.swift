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
    let maxCirclesPerRow: Int = 7
    let circleSize: CGFloat = 12
    let spacing: CGFloat = 4
    var showWeekdayInitials: Bool = false

    var filteredContributions: [Contribution] {
        contributions
            .sorted { $0.date < $1.date }
            .suffix(numberOfDays)
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
        (filteredContributions.count + maxCirclesPerRow - 1) / maxCirclesPerRow
    }

    var body: some View {
        VStack(alignment: .center, spacing: spacing) {
            ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                HStack(spacing: spacing) {
                    ForEach(0..<maxCirclesPerRow, id: \.self) { itemIndex in
                        let overallIndex = rowIndex * maxCirclesPerRow + itemIndex
                        if overallIndex < filteredContributions.count {
                            Circle()
                                .fill(colorForContribution(filteredContributions[overallIndex].count))
                                .strokeBorder(.white.opacity(0.4), lineWidth: (overallIndex == filteredContributions.count - 1) ? 2.5 : 0)
                                .frame(width: circleSize, height: circleSize)
                        } else {
                            EmptyView()
                        }
                    }
                }
            }
        }
        .padding(.vertical, 2)
    }

    private func colorForContribution(_ count: Int) -> Color {
        switch count {
            case 0:
                return Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
            case 1:
                return Color(red: 190 / 255, green: 216 / 255, blue: 253 / 255)
            case 2:
                return Color(red: 132 / 255, green: 178 / 255, blue: 251 / 255)
            case 3:
                return Color(red: 83 / 255, green: 142 / 255, blue: 250 / 255)
            case 4:
                return Color(red: 56 / 255, green: 108 / 255, blue: 249 / 255)
            default:
                return Color(red: 242 / 255, green: 242 / 255, blue: 242 / 255)
        }
    }
}
