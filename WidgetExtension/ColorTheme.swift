//
//  ColorTheme.swift
//  GitHub Stats Widget
//
//  Created by Martin Pluisch on 19.02.24.
//

import SwiftUI

struct ColorTheme {
    let name: String
    let colors: [Int: Color]
    
    static let themes: [ColorTheme] = [
        ColorTheme(name: "Blue", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 190 / 255, green: 216 / 255, blue: 253 / 255),
            2: Color(red: 132 / 255, green: 178 / 255, blue: 251 / 255),
            3: Color(red: 83 / 255, green: 142 / 255, blue: 250 / 255),
            4: Color(red: 56 / 255, green: 108 / 255, blue: 249 / 255)
        ]),
        ColorTheme(name: "Red", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 253 / 255, green: 190 / 255, blue: 190 / 255),
            2: Color(red: 251 / 255, green: 132 / 255, blue: 132 / 255),
            3: Color(red: 250 / 255, green: 83 / 255, blue: 83 / 255),
            4: Color(red: 249 / 255, green: 56 / 255, blue: 56 / 255)
        ]),
        ColorTheme(name: "Green", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 190 / 255, green: 253 / 255, blue: 190 / 255),
            2: Color(red: 132 / 255, green: 251 / 255, blue: 132 / 255),
            3: Color(red: 83 / 255, green: 250 / 255, blue: 83 / 255),
            4: Color(red: 56 / 255, green: 249 / 255, blue: 56 / 255)
        ]),
        ColorTheme(name: "Yellow", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 253 / 255, green: 253 / 255, blue: 190 / 255),
            2: Color(red: 251 / 255, green: 251 / 255, blue: 132 / 255),
            3: Color(red: 250 / 255, green: 250 / 255, blue: 83 / 255),
            4: Color(red: 249 / 255, green: 249 / 255, blue: 56 / 255)
        ]),
        ColorTheme(name: "Monochrome", colors: [
            0: .gray.opacity(0.15),
            1: Color(white: 0.8),
            2: Color(white: 0.6),
            3: Color(white: 0.4),
            4: Color(white: 0.2)
        ])
    ]
    
    static var currentTheme: ColorTheme {
        let userColors = UserDefaults.standard.colorDict(forKey: "widgetColors")
        return ColorTheme(name: "Custom", colors: userColors ?? ColorTheme.themes.first!.colors)
    }
}
