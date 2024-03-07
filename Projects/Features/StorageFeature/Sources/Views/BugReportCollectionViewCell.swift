//
//  BugReportCollectionViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/04/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import AVFoundation
import DesignSystem
import Kingfisher
import UIKit
import Utility

protocol BugReportCollectionViewCellDelegate: AnyObject {
    func tapRemove(index: Int)
}

class BugReportCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!
    @IBOutlet weak var deemView: UIView!

    @IBAction func removeAction(_ sender: Any) {
        self.delegate?.tapRemove(index: index)
    }

    weak var delegate: BugReportCollectionViewCellDelegate?
    var index: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = DesignSystemAsset.GrayColor.gray100.color.cgColor
        self.contentView.clipsToBounds = true
        self.deleteButton.setImage(DesignSystemAsset.Storage.attachRemove.image, for: .normal)
        self.imageView.contentMode = .scaleAspectFill
        self.videoImageView.image = DesignSystemAsset.Storage.playVideo.image
        self.videoImageView.contentMode = .scaleAspectFit
    }
}

extension BugReportCollectionViewCell {
    func update(model: MediaDataType, index: Int) {
        self.index = index

        switch model {
        case let .image(data: data):
            imageView.image = UIImage(data: data)
            videoImageView.isHidden = true
            deemView.backgroundColor = UIColor.clear

        case let .video(data, _):
            imageView.image = data.extractThumbnail()
            videoImageView.isHidden = false
            deemView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
}
