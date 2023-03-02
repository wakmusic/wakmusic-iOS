//
//  RectangleButton.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

internal class RectangleButton: UIButton {
    
    func setColor(title: UIColor, border: UIColor) {
        self.setTitleColor(title, for: .normal)
        self.layer.borderColor = border.cgColor
    }
}
