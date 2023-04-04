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
    
    /// "#RRGGBB", "#RRGGBBAA" 모두 가능
    convenience init?(hex: String) {
            var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

            if hexString.hasPrefix("#") {
                hexString.remove(at: hexString.startIndex)
            }

            guard hexString.count == 6 || hexString.count == 8 else {
                return nil
            }

            let scanner = Scanner(string: hexString)

            var rgbValue: UInt64 = 0
            guard scanner.scanHexInt64(&rgbValue) else {
                return nil
            }

            let red, green, blue, alpha: CGFloat
            if hexString.count == 6 {
                red = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
                green = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
                blue = CGFloat(rgbValue & 0x0000FF) / 255.0
                alpha = 1.0
            } else {
                red = CGFloat((rgbValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((rgbValue & 0x00FF0000) >> 16) / 255.0
                blue = CGFloat((rgbValue & 0x0000FF00) >> 8) / 255.0
                alpha = CGFloat(rgbValue & 0x000000FF) / 255.0
            }

            self.init(red: red, green: green, blue: blue, alpha: alpha)
        }
    
}
