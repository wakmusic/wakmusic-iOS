//
//  ServiceInfoCell.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import Utility

class ServiceInfoCell: UITableViewCell {

    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var subTitleStringLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        arrowImageView.image = DesignSystemAsset.Navigation.serviceInfoArrowRight.image
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleStringLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleStringLabel.setLineSpacing(kernValue: -0.5)
        subTitleStringLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        subTitleStringLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        subTitleStringLabel.setLineSpacing(kernValue: -0.5)
    }
}

extension ServiceInfoCell{
    public func update(model: ServiceInfoGroup) {
        titleStringLabel.text = model.name
        subTitleStringLabel.text = model.subName
        arrowImageView.isHidden = model.accessoryType == .onlyTitle
        stackViewTrailingConstraint.constant = (model.accessoryType == .onlyTitle) ? 24 : 18
    }
}
