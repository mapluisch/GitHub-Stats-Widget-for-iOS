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

