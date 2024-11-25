//
//  RecommendPlayListCell.swift
//  HomeFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Kingfisher
import PlaylistDomainInterface
import UIKit
import Utility

public class RecommendPlayListCell: UICollectionViewCell {
    @IBOutlet weak var titleStringLabel: UILabel!

    @IBOutlet weak var logoImageView: UIImageView!
    override public func awakeFromNib() {
        super.awakeFromNib()

        Task { @MainActor in
            self.contentView.layer.cornerRadius = 8
            self.contentView.layer.borderColor = UIColor.white.cgColor
            self.contentView.layer.borderWidth = 1
            self.contentView.backgroundColor = DesignSystemAsset.GrayColor.gray25.color

            let itemWidth: CGFloat = (APP_WIDTH() - (20 + 8 + 20)) / 2.0
            let itemHeight: CGFloat = (80.0 * itemWidth) / 164.0
            self.logoImageView.layer.cornerRadius = ((48 * itemHeight) / 80.0) / 2.0
        }
    }
}

public extension RecommendPlayListCell {
    func update(model: RecommendPlaylistEntity) {
        let attributedString = NSMutableAttributedString(
            string: model.title,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
                .kern: -0.5
            ]
        )
        titleStringLabel.attributedText = attributedString
        titleStringLabel.numberOfLines = 3

        logoImageView.kf.setImage(
            with: URL(string: model.image),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
