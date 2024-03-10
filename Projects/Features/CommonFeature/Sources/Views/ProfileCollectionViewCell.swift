//
//  ProfileCollectionViewCell.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import Utility
import UserDomainInterface

public enum FanType: String {
    case panchi
    case ifari
    case dulgi
    case bat
    case segyun
    case gorani
    case jupock
    case ddong
}

public class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }
}

public extension ProfileCollectionViewCell {
    func update(_ model: ProfileListEntity) {
        self.imageView.layer.cornerRadius = ((APP_WIDTH() - 70) / 4) / 2
        self.imageView.layer.borderColor = model.isSelected ? DesignSystemAsset.PrimaryColor.point.color
            .cgColor : UIColor.clear.cgColor
        self.imageView.layer.borderWidth = 3

        self.imageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchProfile(name: model.type, version: model.version).toString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
