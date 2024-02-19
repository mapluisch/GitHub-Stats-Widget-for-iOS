//
//  WidgetViewHelpers.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

// MARK: - Helper Functions
extension Int {
    func formatToK() -> String {
        if self >= 1000 {
            let divided = Double(self) / 1000.0
            return String(format: "%.1fk", divided).replacingOccurrences(of: ".0", with: "")
        } else {
            return "\(self)"
        }
    }
}

extension String {
    func slice(from: String, to: String) -> String? {
        (range(of: from)?.upperBound).flatMap { substringFrom in
            (range(of: to, range: substringFrom..<endIndex)?.lowerBound).map { substringTo in
                String(self[substringFrom..<substringTo])
            }
        }
    }
}

extension UserDefaults {
    func setColorDict(_ value: [Int: Color], forKey key: String) {
        let uiColorDict = value.mapValues { UIColor($0) }
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: uiColorDict, requiringSecureCoding: true)
            set(data, forKey: key)
        } catch {
            print("Error saving colors: \(error)")
        }
    }
    
    func colorDict(forKey key: String) -> [Int: Color]? {
        guard let data = data(forKey: key) else { return nil }
        do {
            let decoded = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSDictionary.self, UIColor.self], from: data) as? [Int: UIColor]
            return decoded?.mapValues(Color.init)
        } catch {
            print("Error retrieving colors: \(error)")
            return nil
        }
    }
}

extension Date {
    func isSameDay(as otherDate: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(self, inSameDayAs: otherDate)
    }
}
