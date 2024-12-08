//
//  NoticeCollectionViewCell.swift
//  CommonFeature
//
//  Created by KTH on 2023/04/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import NoticeDomainInterface
import UIKit
import Utility

public final class NoticeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var contentImageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            contentImageView.contentMode = .scaleAspectFill
            contentImageView.clipsToBounds = true
        }
    }
}

public extension NoticeCollectionViewCell {
    func update(model: FetchNoticeEntity.Image) {
        contentImageView.kf.setImage(
            with: URL(string: model.url),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
