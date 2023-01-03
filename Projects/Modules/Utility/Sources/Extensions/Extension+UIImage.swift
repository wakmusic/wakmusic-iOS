//
//  Extension+UIImage.swift
//  Utility
//
//  Created by KTH on 2023/01/02.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit

public extension UIImage {

    static func tabBarTopLine(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return Self() }

        context.setFillColor(color.cgColor)
        context.fill(rect)

        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return Self() }
        UIGraphicsEndImageContext()

        return image
    }
}
