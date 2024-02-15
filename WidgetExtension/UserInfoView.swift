//
//  UserInfoView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 15.02.24.
//

import SwiftUI
import WidgetKit

struct UserInfoView: View {
    var username: String
    var showUsername: Bool
    var colorScheme: ColorScheme
    
    var body: some View {
        HStack {
            Image(colorScheme == .dark ? "github-light" : "github-dark")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(showUsername ? username : "GitHub Stats")
                .font(.headline)
                .minimumScaleFactor(0.5)
                .lineLimit(4)
                .frame(height: 24, alignment: .center)
        }
    }
}

