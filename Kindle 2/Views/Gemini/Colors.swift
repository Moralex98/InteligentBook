//
//  Colors.swift
//  Kindle
//
//  Created by Freddy Morales on 27/02/25.
//

import SwiftUI

extension Color {
    // hex color initializaer
    init(hex: String, opacity: Double = 1.0) {
        let hexSanitized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanInt64(&rgb)
        
        let red = Double((rgb & 0xFF0000) >> 16) / 255.0
        let green = Double((rgb & 0x00FF00) >> 16) / 255.0
        let blue = Double((rgb & 0x0000FF) >> 16) / 255.0
        
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    // primary color
    static let primaryColor1 = Color.blue
    static let primaryColor2 = Color.purple
    static let primaryColor3 = Color.pink
    static let hightLightColor = Color(hex: "#F0F6FB")
}
