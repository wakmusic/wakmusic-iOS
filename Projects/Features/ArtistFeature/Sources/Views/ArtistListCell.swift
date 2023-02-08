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
        
        artistLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        artistLabel.textColor = DesignSystemAsset.GrayColor.gray600.color
        artistLabel.setLineSpacing(kernValue: -1)
        artistLabel.textAlignment = .center
    }
}

extension ArtistListCell {

    func update(model: ArtistListEntity) {

        self.contentView.alpha = model.isHiddenItem ? 0 : 1
        
        artistLabel.text = model.name
        artistImageView.kf.setImage(with: URL(string: "https://static.wakmusic.xyz/static/artist/round/\(model.ID).png"),
                                    placeholder: nil,
                                    options: [.transition(.fade(0.2))])

    }
}
