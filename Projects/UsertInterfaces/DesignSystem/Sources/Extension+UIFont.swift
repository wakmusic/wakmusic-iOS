//
//  Extension+UIFont.swift
//  DesignSystem
//
//  Created by YoungK on 11/22/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

protocol WMFontable {
    var font: UIFont { get }
}

public extension UIFont {
    enum WMFontSystem: WMFontable {
        case header1
        case header2
        case header3
        case subtitle1
        case subtitle2
        case subtitle3
        case body1
        case body2
        case body3
        case caption1
        case caption2
    }
    
    static func setFont(_ style: WMFontSystem) -> UIFont {
        return style.font
    }
    
}

public extension UIFont.WMFontSystem {
    var font: UIFont {
        switch self {
        case .header1:
            return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 16) ?? .init()
        case .header2:
            return .init()
        case .header3:
            return .init()
        case .subtitle1:
            return .init()
        case .subtitle2:
            return .init()
        case .subtitle3:
            return .init()
        case .body1:
            return .init()
        case .body2:
            return .init()
        case .body3:
            return .init()
        case .caption1:
            return .init()
        case .caption2:
            return .init()
        }
    }
}
