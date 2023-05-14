//
//  BugReportCollectionViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/04/15.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import Kingfisher
import Utility
import AVFoundation

protocol BugReportCollectionViewCellDelegate: AnyObject {
    func tapRemove(index: Int)
}

class BugReportCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var videoImageView: UIImageView!
    
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
        case .image(data: let data):
            imageView.image = UIImage(data: data)
            videoImageView.isHidden = true
            contentView.backgroundColor = .clear
            
        case let .video(data, _):
            imageView.image = data.extractThumbnail()
            videoImageView.isHidden = false
            contentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }
    }
}
