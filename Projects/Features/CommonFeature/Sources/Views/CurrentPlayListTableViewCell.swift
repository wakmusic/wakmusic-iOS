//
//  CurrentPlayListTableViewCell.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import DomainModule
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
        self.playListNameLabel.setLineSpacing(kernValue: -0.5)
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.playListCountLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playListCountLabel.setLineSpacing(kernValue: -0.5)
    }
}

extension CurrentPlayListTableViewCell {
    func update(model:PlayListEntity) {
        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.image),version: model.image_version).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))])
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songlist.count)곡"
    }
}
