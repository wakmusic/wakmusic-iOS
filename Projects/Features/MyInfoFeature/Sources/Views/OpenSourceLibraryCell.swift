//
//  OpenSourceLicenseCell.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import Utility

public class OpenSourceLibraryCell: UITableViewCell {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override public func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        titleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        titleStringLabel.setTextWithAttributes(kernValue: -0.5)
        titleStringLabel.numberOfLines = 0
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 13)
        descriptionLabel.textColor = DesignSystemAsset.BlueGrayColor.gray500.color
        descriptionLabel.setTextWithAttributes(kernValue: -0.5)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
    }
}

public extension OpenSourceLibraryCell {
    static func getCellHeight(model: OpenSourceLicense) -> CGFloat {
        let baseMargin: CGFloat = 25
        let titleAttributedString = NSAttributedString(
            string: model.title,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.bold.font(size: 15),
                .kern: -0.5
            ]
        )
        let titleHeight: CGFloat = titleAttributedString.height(containerWidth: APP_WIDTH() - 40)

        let descriptionAttributedString = NSAttributedString(
            string: model.description,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 13),
                .kern: -0.5
            ]
        )
        let descriptionHeight: CGFloat = descriptionAttributedString.height(containerWidth: APP_WIDTH() - 50)

        return baseMargin + titleHeight + descriptionHeight
    }

    func update(model: OpenSourceLicense) {
        titleStringLabel.text = model.title
        descriptionLabel.text = model.description
    }
}
