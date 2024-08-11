//
//  ArtistListCell.swift
//  WaktaverseMusic
//
//  Created by KTH on 2022/12/15.
//

import ArtistDomainInterface
import DesignSystem
import Kingfisher
import UIKit
import Utility

class ArtistListCell: UICollectionViewCell {
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension ArtistListCell {
    func update(model: ArtistEntity) {
        self.contentView.alpha = model.isHiddenItem ? 0 : 1
        let artistNameAttributedString = NSMutableAttributedString(
            string: model.krName,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray600.color,
                .kern: -0.5
            ]
        )
        let encodedImageURLString: String = model.roundImage
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? model.roundImage

        artistLabel.attributedText = artistNameAttributedString
        artistLabel.textAlignment = .center
        artistImageView.kf.setImage(
            with: URL(string: encodedImageURLString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
