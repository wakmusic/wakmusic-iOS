//
//  NoticeCollectionViewCell.swift
//  CommonFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility

public class NoticeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        contentImageView.contentMode = .scaleAspectFill
        contentImageView.clipsToBounds = true
    }
}

public extension NoticeCollectionViewCell {
    func update(model: String) {
        contentImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchNotice(id: model).toString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
