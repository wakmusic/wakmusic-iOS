//
//  CurrentPlayListTableViewCell.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import UserDomainInterface
import Utility

class CurrentPlayListTableViewCell: UITableViewCell {
    @IBOutlet weak var playListImageView: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.playListImageView.layer.cornerRadius = 4
        self.playListNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.playListNameLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playListNameLabel.setTextWithAttributes(kernValue: -0.5)
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.playListCountLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playListCountLabel.setTextWithAttributes(kernValue: -0.5)
    }
}

extension CurrentPlayListTableViewCell {
    func update(model: PlaylistEntity) {
        self.playListImageView.kf.setImage(
            with: URL(string: model.image),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songCount)곡"
    }
}
