//
//  Extension+UIColor.swift
//  Utility
//
//  Created by YoungK on 2023/02/12.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import SwiftUI

public extension UIColor {
    var color: Color {
        get {
            let rgbColours = self.cgColor.components
            return Color(
                red: Double(rgbColours![0]),
                green: Double(rgbColours![1]),
                blue: Double(rgbColours![2])
            )
        }
    }

    static func random() -> UIColor {
        return UIColor(
            red: CGFloat(Float.random(in: 0 ..< 1)),
            green: CGFloat(Float.random(in: 0 ..< 1)),
            blue: CGFloat(Float.random(in: 0 ..< 1)),
            alpha: 1.0
        )
    }

    /// - Parameter hex: "#FF00EE"
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()

        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }

        assert(hexFormatted.count == 6, "Invalid hex code used.")

        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)

        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}
