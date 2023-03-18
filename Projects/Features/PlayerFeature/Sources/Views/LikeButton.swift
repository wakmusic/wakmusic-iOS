//
//  LikeButton.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

protocol Toggleable {
    var isOn: Bool { get set }
}

internal class LikeButton: VerticalButton, Toggleable {
    var isOn: Bool = false {
        didSet {
            setColor()
            setImage()
        }
    }
    
    private func setColor() {
        let color = isOn ? DesignSystemAsset.PrimaryColor.increase.color : DesignSystemAsset.GrayColor.gray400.color
        self.setTitleColor(color, for: .normal)
    }
    
    private func setImage() {
        let image = isOn ? DesignSystemAsset.Player.likeOn.image : DesignSystemAsset.Player.likeOff.image
        self.setImage(image, for: .normal)
    }
}
