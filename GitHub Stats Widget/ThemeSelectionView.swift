//
//  ThemeSelectionView.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 19.02.24.
//

import SwiftUI

struct ThemeSelectionView: View {
    @State private var selectedColors: [Int: Color] = UserDefaults.standard.colorDict(forKey: "widgetColors") ?? ContributionColors.defaults
    
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
                                .onTapGesture {
                                    selectedColors = theme.colors
                                    UserDefaults.standard.setColorDict(selectedColors, forKey: "widgetColors")
                                }
                        }
                        if isSelectedTheme(theme) {
                            Image(systemName: "checkmark.circle")
                        }
                    }
                }
            }
            
            Section(header: Text("Customize Colors")) {
                ForEach(0..<5) { count in
                    HStack {
                        Text("Contribution Level \(count)")
                        Spacer()
                        ColorPicker("Select Color", selection: binding(for: count))
                    }
                }
            }
        }
        .navigationTitle("Theme Colors")
    }
    
    private func binding(for count: Int) -> Binding<Color> {
        Binding<Color>(
            get: { self.selectedColors[count, default: ContributionColors.defaults[count, default: .gray.opacity(0.15)]] },
            set: {
                self.selectedColors[count] = $0
                UserDefaults.standard.setColorDict(self.selectedColors, forKey: "widgetColors")
            }
        )
    }
}
