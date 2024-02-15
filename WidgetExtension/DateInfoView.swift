//
//  DateInfoView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct DateInfoView: View {
    var body: some View {
        HStack {
            Text(currentDateTimeString())
                .font(.system(size: 14, weight: .light))
                .minimumScaleFactor(0.5)
                .lineLimit(1)
        }
    }
    
    private func currentDateTimeString() -> String {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        return formatter.string(from: now)
    }
}
