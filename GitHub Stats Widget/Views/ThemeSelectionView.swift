//
//  ThemeSelectionView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 19.02.24.
//

import SwiftUI
import WidgetKit

struct ThemeSelectionView: View {
    @State private var selectedColors: [Int: Color] = UserDefaults.colorDict(forKey: "widgetColors") ?? ColorTheme.defaults
    
    private func isSelectedTheme(_ theme: ColorTheme) -> Bool {
        theme.colors == selectedColors
    }

    var body: some View {
        List {
            Section(header: Text("Predefined Themes")) {
                ForEach(ColorTheme.themes, id: \.name) { theme in
                    HStack {
                        Text(theme.name)
                        Spacer()
                        ForEach(0..<5) { count in
                            Circle()
                                .fill(theme.colors[count, default: .gray.opacity(0.15)])
                                .frame(width: 18, height: 18)
                        }
                        if isSelectedTheme(theme) {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                    .onTapGesture {
                        selectedColors = theme.colors
                        UserDefaults.setColorDict(selectedColors, forKey: "widgetColors")
                    }
                }
            }
            
            Section(header: Text("Customize Colors")) {
                ForEach(0..<5) { count in
                    HStack {
                        Text("\(contributionCountToString(count: count)) contributions")
                            .fixedSize(horizontal: true, vertical: false)
                        ColorPicker("", selection: binding(for: count))
                    }
                }
            }
        }
        .navigationTitle("Theme Colors")
    }
    
    private func contributionCountToString(count: Int) -> String {
        switch(count) {
            case 0: return "No"
            case 1: return "Low"
            case 2: return "Medium"
            case 3: return "Medium-High"
            case 4: return "High"
            default: return ""
        }
    }
    
    private func binding(for count: Int) -> Binding<Color> {
        Binding<Color>(
            get: { self.selectedColors[count, default: ColorTheme.defaults[count, default: .gray.opacity(0.15)]] },
            set: {
                self.selectedColors[count] = $0
                UserDefaults.setColorDict(self.selectedColors, forKey: "widgetColors")
            }
        )
    }
}
