//
//  NoticeListCell.swift
//  StorageFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DomainModule
import Utility
import DesignSystem

class NoticeListCell: UITableViewCell {

    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
}

extension NoticeListCell {
    func update(model: FetchNoticeEntity) {
        titleStringLabel.text = model.title
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleStringLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        titleStringLabel.setLineSpacing(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 1.26)

        dayLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        dayLabel.text = (model.createAt/1000.0).unixTimeToDate.dateToString(format: "yy.MM.dd")
        dayLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        dayLabel.setLineSpacing(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 0)
        
        timeLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        timeLabel.text = (model.createAt/1000.0).unixTimeToDate.dateToString(format: "HH:mm")
        timeLabel.textColor = DesignSystemAsset.GrayColor.gray500.color
        timeLabel.setLineSpacing(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 0)
    }
}
