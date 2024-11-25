//
//  ServiceInfoCell.swift
//  CommonFeature
//
//  Created by KTH on 2023/05/17.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import Utility

class ServiceInfoCell: UITableViewCell {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var subTitleStringLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            arrowImageView.image = DesignSystemAsset.Navigation.serviceInfoArrowRight.image
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear
            titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            titleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
            titleStringLabel.setTextWithAttributes(kernValue: -0.5)
            subTitleStringLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            subTitleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.gray500.color
            subTitleStringLabel.setTextWithAttributes(kernValue: -0.5)
        }
    }
}

extension ServiceInfoCell {
    public func update(model: ServiceInfoGroup) {
        titleStringLabel.text = model.name
        subTitleStringLabel.text = model.subName
        subTitleStringLabel.font = (model.identifier == .versionInfomation) ? DesignSystemFontFamily.SCoreDream._3Light
            .font(size: 12) : DesignSystemFontFamily.Pretendard.light.font(size: 12)
        arrowImageView.isHidden = model.accessoryType == .onlyTitle
        stackViewTrailingConstraint.constant = (model.accessoryType == .onlyTitle) ? 24 : 18
        selectionStyle = (model.identifier == .versionInfomation) ? .none : .default
    }
}
