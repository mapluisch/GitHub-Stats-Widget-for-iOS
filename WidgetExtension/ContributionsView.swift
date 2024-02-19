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
    let circleSize: CGFloat = 12
    let spacing: CGFloat = 4
    
    private var calendar: Calendar {
        var cal = Calendar.current
        cal.firstWeekday = 2
        return cal
    }
    
    private var dates: [Date] {
        guard let startDate = calendar.date(byAdding: .day, value: -(numberOfDays - 1), to: Date()) else { return [] }
        var dates = (0..<numberOfDays).compactMap { calendar.date(byAdding: .day, value: $0, to: startDate) }
        
        if (numberOfDays == 7) {
            return dates
        }
        
        var futureDatesCount = 0
        
        if let lastDate = dates.last {
                let lastDateWeekday = calendar.component(.weekday, from: lastDate)
                let saturday = 7
                if lastDateWeekday != saturday {
                    var nextDate = lastDate
                    while calendar.component(.weekday, from: nextDate) != saturday {
                        futureDatesCount += 1
                        guard let nextDay = calendar.date(byAdding: .day, value: 1, to: nextDate) else { break }
                        nextDate = nextDay
                        dates.append(nextDate)
                    }
                }
            }
        
        if futureDatesCount > 0 {
            dates.removeFirst(min(futureDatesCount, dates.count))
        }
        
        return dates
    }
    
    private func contributionForDate(_ date: Date) -> Contribution? {
        contributions.first { calendar.isDate($0.date, inSameDayAs: date) }
    }
    
    private func colorForContribution(_ count: Int?) -> Color {
        switch count {
        case .none, 0: return Color.gray.opacity(0.15)
            case 1: return Color(red: 190 / 255, green: 216 / 255, blue: 253 / 255)
            case 2: return Color(red: 132 / 255, green: 178 / 255, blue: 251 / 255)
            case 3: return Color(red: 83 / 255, green: 142 / 255, blue: 250 / 255)
            case 4: return Color(red: 56 / 255, green: 108 / 255, blue: 249 / 255)
            default: return Color.gray.opacity(0.15)
        }
    }

    var body: some View {
        if numberOfDays <= 7 {
            HStack(spacing: spacing) {
                ForEach(dates, id: \.self) { date in
                    if let contribution = contributionForDate(date) {
                        Circle()
                            .fill(colorForContribution(contribution.count))
                            .frame(width: circleSize, height: circleSize)
                    }
                }
            }
        } else {
            let rows = Array(repeating: GridItem(.fixed(circleSize), spacing: spacing), count: 7)
            LazyHGrid(rows: rows, spacing: spacing) {
                ForEach(dates, id: \.self) { date in
                    if let contribution = contributionForDate(date) {
                        Circle()
                            .fill(colorForContribution(contribution.count))
                            .frame(width: circleSize, height: circleSize)
                    } else {
                        Circle()
                            .fill(Color.clear)
                            .frame(width: circleSize, height: circleSize)
                    }
                }
            }
        }
    }
}
