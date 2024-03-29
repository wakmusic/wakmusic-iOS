//
//  RecentRecordTableViewCell.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import UIKit
import Utility

protocol RecentRecordDelegate: AnyObject {
    func selectedItems(_ keyword: String)
}

class RecentRecordTableViewCell: UITableViewCell {
    /*
     해당 클래스 이름은 , 스토리보드 TableViewCell의
     Class 이름과 Identifier쪽에 모두 넣어줘야함
     또한
     tableView.dequeueReusableCell(withIdentifier: <#T##String#>)
     withIdentifier에도 넣어줘야함
     */

    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var recentRemoveButton: UIButton!

    override func awakeFromNib() { // View의 DidLoad쪽과 같은 역할
        super.awakeFromNib()

        recentRemoveButton.setImage(DesignSystemAsset.Search.keywordRemove.image, for: .normal)
        recentLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        recentLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        recentLabel.setTextWithAttributes(kernValue: -0.5)
    }

    @IBAction func pressRemoveAction(_ sender: Any) {
        PreferenceManager.shared.removeRecentRecords(word: self.recentLabel.text!)
    }
}
