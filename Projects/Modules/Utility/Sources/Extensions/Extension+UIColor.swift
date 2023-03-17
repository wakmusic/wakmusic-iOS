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
    
    
    
}
