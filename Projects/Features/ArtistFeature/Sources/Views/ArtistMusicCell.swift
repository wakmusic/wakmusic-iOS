//
//  ArtistMusicCell.swift
//  ArtistFeature
//
//  Created by KTH on 2023/01/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem

class ArtistMusicCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var groupStringLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        albumImageView.layer.cornerRadius = 8
        albumImageView.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        albumImageView.layer.borderWidth = 1

        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        groupStringLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        releaseDateLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
    }
}

extension ArtistMusicCell {
    
    static func getCellHeight() -> CGFloat {
        let base: CGFloat = 10 + 10
        let width: CGFloat = (72.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = (width * 40.0) / 72.0

        return base + height
    }
    
    func update() {
        albumImageView.image = DesignSystemAsset.Logo.placeHolderSmall.image
    }
}
