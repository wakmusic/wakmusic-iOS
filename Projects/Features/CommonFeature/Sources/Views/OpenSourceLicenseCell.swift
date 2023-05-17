//
//  OpenSourceLicenseCell.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import Utility

public class OpenSourceLicenseCell: UITableViewCell {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var topLineLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 15)
        titleStringLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleStringLabel.setLineSpacing(kernValue: -0.5)
        titleStringLabel.numberOfLines = 0
        descriptionLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 13)
        descriptionLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        descriptionLabel.setLineSpacing(kernValue: -0.5)
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.numberOfLines = 0
        topLineLabel.backgroundColor = DesignSystemAsset.GrayColor.gray200.color
    }
}

extension OpenSourceLicenseCell {
    public func update(model: OpenSourceLicense){
        titleStringLabel.text = model.title
        descriptionLabel.text = model.description
        topLineLabel.isHidden = !model.showTopLine
        selectionStyle = model.clickable ? .default : .none
    }
}
