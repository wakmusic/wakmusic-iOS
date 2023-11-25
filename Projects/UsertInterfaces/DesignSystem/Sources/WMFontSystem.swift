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
            case light, medium, bold
        }
        
        case t1(weight: WMFontWeight = .medium)
        case t2(weight: WMFontWeight = .medium)
        case t3(weight: WMFontWeight = .medium)
        case t4(weight: WMFontWeight = .medium)
        case t5(weight: WMFontWeight = .medium)
        case t6(weight: WMFontWeight = .medium)
        case t6_1(weight: WMFontWeight = .medium)
        case t7(weight: WMFontWeight = .medium)
        case t7_1(weight: WMFontWeight = .medium)
        case t8(weight: WMFontWeight = .medium)
        
        var font: UIFont {
            return UIFont(font: weight.font, size: size) ?? .init()
        }
        
        var lineHeight: CGFloat {
            return height
        }
        
        private var weight: WMFontWeight {
            switch self {
            case let .t1(weight),
                 let .t2(weight),
                 let .t3(weight),
                 let .t4(weight),
                 let .t5(weight),
                 let .t6(weight),
                 let .t6_1(weight),
                 let .t7(weight),
                 let .t7_1(weight),
                 let .t8(weight):
                return weight
            }
        }
        
        private var size: CGFloat {
            switch self {
            case .t1: return 24
            case .t2: return 22
            case .t3: return 20
            case .t4: return 18
            case .t5: return 16
            case .t6: return 14
            case .t6_1: return 14
            case .t7: return 12
            case .t7_1: return 12
            case .t8: return 11
            }
        }
        
        private var height: CGFloat {
            switch self {
            case .t1: return 36
            case .t2: return 32
            case .t3: return 32
            case .t4: return 28
            case .t5: return 24
            case .t6: return 20
            case .t6_1: return 20
            case .t7_1: return 14
            case .t7: return 18
            case .t8: return 16
            }
        }
    }
    
    static func setFont(_ style: WMFontSystem) -> UIFont {
        return style.font
    }
    
}

public extension UIFont.WMFontSystem.WMFontWeight {
    var font: DesignSystemFontConvertible {
        switch self {
        case .light: return DesignSystemFontFamily.Pretendard.light
        case .medium: return DesignSystemFontFamily.Pretendard.medium
        case .bold: return DesignSystemFontFamily.Pretendard.bold
        }
    }
}

let font: UIFont = .WMFontSystem.t1(weight: .medium).font
