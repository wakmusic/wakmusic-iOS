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
import DomainModule

class ArtistMusicCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var groupStringLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        
        albumImageView.layer.cornerRadius = 4
        albumImageView.contentMode = .scaleAspectFill
        
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        groupStringLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        releaseDateLabel.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
    }
}

extension ArtistMusicCell {
    
    static func getCellHeight() -> CGFloat {
        let base: CGFloat = 10 + 10
        let width: CGFloat = (72.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = (width * 40.0) / 72.0
        return base + height
    }
    
    func update(model: ArtistSongListEntity) {
        
        self.contentView.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        
        titleStringLabel.attributedText = getAttributedString(
            text: model.title,
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        )
        
        groupStringLabel.attributedText = getAttributedString(
            text: model.artist,
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12)
        )
        
        releaseDateLabel.attributedText = getAttributedString(
            text: model.date,
            font: DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
        )
        
        albumImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.ID).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
    }
    
    private func getAttributedString(
        text: String,
        font: UIFont
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        return attributedString
    }
}
