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
        ColorTheme(name: "GitHub Default", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 0x1a / 255, green: 0x5a / 255, blue: 0x3b / 255),
            2: Color(red: 0x00 / 255, green: 0x6d / 255, blue: 0x32 / 255),
            3: Color(red: 0x26 / 255, green: 0xa6 / 255, blue: 0x41 / 255),
            4: Color(red: 0x4b / 255, green: 0xe8 / 255, blue: 0x63 / 255),
        ]),
        ColorTheme(name: "GitHub Halloween", colors: [
            1: Color(red: 0x63 / 255, green: 0x1c / 255, blue: 0x03 / 255),
            2: Color(red: 0xbd / 255, green: 0x56 / 255, blue: 0x1d / 255),
            3: Color(red: 0xfa / 255, green: 0x7a / 255, blue: 0x18 / 255),
            4: Color(red: 0xfd / 255, green: 0xdf / 255, blue: 0x68 / 255),
        ]),
        ColorTheme(name: "GitHub Winter", colors: [
            1: Color(red: 0x0a / 255, green: 0x30 / 255, blue: 0x69 / 255),
            2: Color(red: 0x09 / 255, green: 0x69 / 255, blue: 0xda / 255),
            3: Color(red: 0x54 / 255, green: 0xae / 255, blue: 0xff / 255),
            4: Color(red: 0xb6 / 255, green: 0xe3 / 255, blue: 0xff / 255),
        ]),
        ColorTheme(name: "Red", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 120 / 255, green: 27 / 255, blue: 30 / 255),
            2: Color(red: 170 / 255, green: 36 / 255, blue: 45 / 255),
            3: Color(red: 225 / 255, green: 65 / 255, blue: 75 / 255),
            4: Color(red: 255 / 255, green: 88 / 255, blue: 90 / 255)
        ]),
        ColorTheme(name: "Yellow", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 120 / 255, green: 120 / 255, blue: 27 / 255),
            2: Color(red: 170 / 255, green: 170 / 255, blue: 36 / 255),
            3: Color(red: 225 / 255, green: 225 / 255, blue: 65 / 255),
            4: Color(red: 255 / 255, green: 255 / 255, blue: 88 / 255)
        ]),
        ColorTheme(name: "Beige", colors: [
            0: .gray.opacity(0.15),
            1: Color(red: 0x76 / 255, green: 0x5E / 255, blue: 0x49 / 255),
            2: Color(red: 0x9E / 255, green: 0x8B / 255, blue: 0x78 / 255),
            3: Color(red: 0xC3 / 255, green: 0xB1 / 255, blue: 0xA1 / 255),
            4: Color(red: 0xDA / 255, green: 0xCB / 255, blue: 0xBF / 255),
        ]),
        ColorTheme(name: "Monochrome", colors: [
            0: .gray.opacity(0.15),
            1: Color(white: 0.8),
            2: Color(white: 0.6),
            3: Color(white: 0.4),
            4: Color(white: 0.2)
        ])
    ]
    
    static let defaults: [Int: Color] = [
        0: .gray.opacity(0.15),
        1: Color(red: 0x0a / 255, green: 0x30 / 255, blue: 0x69 / 255),
        2: Color(red: 0x09 / 255, green: 0x69 / 255, blue: 0xda / 255),
        3: Color(red: 0x54 / 255, green: 0xae / 255, blue: 0xff / 255),
        4: Color(red: 0xb6 / 255, green: 0xe3 / 255, blue: 0xff / 255),
    ]
    
    static var currentTheme: ColorTheme {
        let userColors = UserDefaults.colorDict(forKey: "widgetColors")
        return ColorTheme(name: "Custom", colors: userColors ?? ColorTheme.themes.first!.colors)
    }
}
