//
//  NoticeListCell.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import DomainModule
import UIKit
import Utility

class NoticeListCell: UITableViewCell {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear

        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleStringLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleStringLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 1.26)

        dayLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        dayLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        dayLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 0)

        timeLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        timeLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        timeLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 0)
    }
}

extension NoticeListCell {
    func update(model: FetchNoticeEntity) {
        titleStringLabel.text = model.title
        dayLabel.text = (model.createdAt / 1000.0).unixTimeToDate.dateToString(format: "yy.MM.dd")
        timeLabel.text = (model.createdAt / 1000.0).unixTimeToDate.dateToString(format: "HH:mm")
    }
}
