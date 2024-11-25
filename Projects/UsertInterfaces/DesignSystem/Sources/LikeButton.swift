//
//  LikeButton.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/03/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit

class LikeButton: VerticalImageButton {
    var isLiked: Bool = false {
        didSet {
            setColor()
            setImage()
        }
    }

    private func setColor() {
        let color = isLiked ? DesignSystemAsset.PrimaryColor.increase.color : DesignSystemAsset.GrayColor.gray400.color
        self.titleLabel.textColor = color
    }

    private func setImage() {
        let image = isLiked ? DesignSystemAsset.Player.likeOn.image : DesignSystemAsset.Player.likeOff.image
        self.image = image
    }
}
