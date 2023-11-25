//
//  WMFontSystem.swift
//  DesignSystem
//
//  Created by YoungK on 11/22/23.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

protocol WMFontable {
    var font: UIFont { get }
    var lineHeight: CGFloat { get }
}

public extension UIFont {
    enum WMFontSystem: WMFontable {
        public enum WMFontWeight {
            case light
            case medium
            case bold
        }
        
        case t1(weight: WMFontWeight = .medium)
        case t2(weight: WMFontWeight = .medium)
        case t3(weight: WMFontWeight = .medium)
        case t4(weight: WMFontWeight = .medium)
        case t5(weight: WMFontWeight = .medium)
        case t6(weight: WMFontWeight = .medium)
        case t6_1(Weight: WMFontWeight = .medium)
        case t7(weight: WMFontWeight = .medium)
        case t7_1(weight: WMFontWeight = .medium)
        case t8(weight: WMFontWeight = .medium)
    }
    
    static func setFont(_ style: WMFontSystem) -> UIFont {
        return style.font
    }
}

public extension UIFont.WMFontSystem.WMFontWeight {
    var font: DesignSystemFontConvertible {
        switch self {
        case .light:
            return DesignSystemFontFamily.Pretendard.light
        case .medium:
            return DesignSystemFontFamily.Pretendard.medium
        case .bold:
            return DesignSystemFontFamily.Pretendard.bold
        }
    }
}

public extension UIFont.WMFontSystem {
    var font: UIFont {
        switch self {
        case let .t1(weight):
            return UIFont(font: weight.font, size: 24) ?? .init()

        case let .t2(weight):
            return UIFont(font: weight.font, size: 22) ?? .init()
            
        case let .t3(weight):
            return UIFont(font: weight.font, size: 20) ?? .init()
            
        case let .t4(weight):
            return UIFont(font: weight.font, size: 18) ?? .init()
            
        case let .t5(weight):
            return UIFont(font: weight.font, size: 16) ?? .init()
            
        case let .t6(weight):
            return UIFont(font: weight.font, size: 14) ?? .init()

        case let .t6_1(weight):
            return UIFont(font: weight.font, size: 14) ?? .init()
            
        case let .t7(weight):
            return UIFont(font: weight.font, size: 12) ?? .init()

        case let .t7_1(weight):
            return UIFont(font: weight.font, size: 12) ?? .init()

        case let .t8(weight):
            return UIFont(font: weight.font, size: 11) ?? .init()
        }
    }
}

public extension UIFont.WMFontSystem {
    var lineHeight: CGFloat {
        switch self {
        case .t1:
            return 36
        case .t2:
            return 32
        case .t3:
            return 32
        case .t4:
            return 28
        case .t5:
            return 24
        case .t6:
            return 24
        case .t6_1:
            return 20
        case .t7:
            return 18
        case .t7_1:
            return 14
        case .t8:
            return 16
        }
    }
}
