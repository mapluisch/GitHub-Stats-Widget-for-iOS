//
//  IconWithTextView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct IconAndTextView: View {
    var type: String
    var currentCount: Int
    var previousCount: Int
    
    var body: some View {
        HStack {
            Spacer()
            Image(systemName: "\(type).fill")
                .scaledToFit()
                .frame(width: 16, height: 16)
            CountTextView(prefix: "", currentCount: currentCount, previousCount: previousCount)
        }
    }
}
