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

public extension UIFont.WMFontSystem {
    var font: UIFont {
        switch self {
        case let .t1(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 24) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 24) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 24) ?? .init()
            }
        case let .t2(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 22) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 22) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 22) ?? .init()
            }
        case let .t3(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 20) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 20) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 20) ?? .init()
            }
        case let .t4(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 18) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 18) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 18) ?? .init()
            }
        case let .t5(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 16) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 16) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 16) ?? .init()
            }
        case let .t6(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 14) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 14) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 14) ?? .init()
            }
        case let .t6_1(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 14) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 14) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 14) ?? .init()
            }
        case let .t7(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 12) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 12) ?? .init()
            }
        case let .t7_1(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 12) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 12) ?? .init()
            }
        case let .t8(weight):
            switch weight {
            case .light:
                return UIFont(font: DesignSystemFontFamily.Pretendard.light, size: 11) ?? .init()
            case .medium:
                return UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 11) ?? .init()
            case .bold:
                return UIFont(font: DesignSystemFontFamily.Pretendard.bold, size: 11) ?? .init()
            }
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
