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
        /// size: 24 height: 36
        case t1(weight: WMFontWeight = .medium)
        /// size: 22 height: 32
        case t2(weight: WMFontWeight = .medium)
        /// size: 20 height: 32
        case t3(weight: WMFontWeight = .medium)
        /// size: 18 height: 28
        case t4(weight: WMFontWeight = .medium)
        /// size: 16 height: 24
        case t5(weight: WMFontWeight = .medium)
        /// size: 14 height: 22
        case t6(weight: WMFontWeight = .medium)
        /// size: 14 height: 20
        case t6_1(weight: WMFontWeight = .medium)
        /// size: 12 height: 18
        case t7(weight: WMFontWeight = .medium)
        /// size: 12 height: 14
        case t7_1(weight: WMFontWeight = .medium)
        /// size: 11 height: 16
        case t8(weight: WMFontWeight = .medium)
        /// size: 12 height: 18
        case sc7(weight: WMFontWeight = .score3Light)
    }

    static func setFont(_ style: WMFontSystem) -> UIFont {
        return style.font
    }
}

public extension UIFont.WMFontSystem {
    enum WMFontWeight {
        case light, medium, bold, score3Light
    }

    var font: UIFont {
        return UIFont(font: weight.font, size: size) ?? .init()
    }

    var lineHeight: CGFloat {
        return height
    }
}

private extension UIFont.WMFontSystem {
    var weight: WMFontWeight {
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
             let .t8(weight),
             let .sc7(weight: weight):
            return weight
        }
    }

    var size: CGFloat {
        switch self {
        case .t1: return 24
        case .t2: return 22
        case .t3: return 20
        case .t4: return 18
        case .t5: return 16
        case .t6: return 14
        case .t6_1: return 14
        case .t7, .sc7: return 12
        case .t7_1: return 12
        case .t8: return 11
        }
    }

    var height: CGFloat {
        switch self {
        case .t1: return 36
        case .t2: return 32
        case .t3: return 32
        case .t4: return 28
        case .t5: return 24
        case .t6: return 22
        case .t6_1: return 20
        case .t7, .sc7: return 18
        case .t7_1: return 14
        case .t8: return 16
        }
    }
}

public extension UIFont.WMFontSystem.WMFontWeight {
    var font: DesignSystemFontConvertible {
        switch self {
        case .light: return DesignSystemFontFamily.Pretendard.light
        case .medium: return DesignSystemFontFamily.Pretendard.medium
        case .bold: return DesignSystemFontFamily.Pretendard.bold
        case .score3Light: return DesignSystemFontFamily.SCoreDream._3Light
        }
    }
}
