//
//  CountTextView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI

struct CountTextView: View {
    var prefix: String
    var currentCount: Int
    var previousCount: Int

    private var formattedCount: String {
        currentCount.formatToK()
    }
    
    private var arrow: String {
        currentCount > previousCount ? "↑" : currentCount < previousCount ? "↓" : ""
    }
    
    private var arrowColor: Color {
        currentCount > previousCount ? .green : .red
    }

    var body: some View {
        HStack {
            Text("\(prefix)\(formattedCount)")
                .minimumScaleFactor(0.8)
            if !arrow.isEmpty {
                Text(arrow)
                    .foregroundColor(arrowColor)
            }
        }
    }
}

