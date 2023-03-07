//
//  RectangleButton.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

internal class RectangleButton: UIButton {
    
    func setColor(isHighlight: Bool) {
        let pointColor = DesignSystemAsset.PrimaryColor.point.color
        if isHighlight {
            self.setColor(title: pointColor, border: pointColor)
        } else {
            self.setColor(title: DesignSystemAsset.GrayColor.gray400.color, border: DesignSystemAsset.GrayColor.gray300.color)
        }
    }
    
    func setColor(title: UIColor, border: UIColor) {
        self.setTitleColor(title, for: .normal)
        self.layer.borderColor = border.cgColor
    }
}
