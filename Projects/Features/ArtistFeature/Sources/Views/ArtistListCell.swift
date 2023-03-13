//
//  ArtistListCell.swift
//  WaktaverseMusic
//
//  Created by KTH on 2022/12/15.
//

import UIKit
import Kingfisher
import Utility
import DomainModule
import DesignSystem

class ArtistListCell: UICollectionViewCell {

    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ArtistListCell {

    func update(model: ArtistListEntity) {

        self.contentView.alpha = model.isHiddenItem ? 0 : 1
        
        let artistNameAttributedString = NSMutableAttributedString(
            string: model.name,
            attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
                         .kern: -1]
        )
        
        artistLabel.attributedText = artistNameAttributedString
        artistLabel.textAlignment = .center
        artistImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchArtistWithRound(id: model.ID, version: model.imageRoundVersion).toString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
