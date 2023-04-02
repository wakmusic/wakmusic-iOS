//
//  MyPlayListTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import DomainModule
import Kingfisher
import Utility

public protocol PlayListPlayButtonDelegate: AnyObject {
    func play(key: String)
}

public protocol MyPlayListTableViewCellDelegate: AnyObject {
    func listTapped(indexPath: IndexPath)
}

class MyPlayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playListImageView: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectButton: UIButton!
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        playButtonDelegate?.play(key: key)
    }
    
    @IBAction func listSelectButtonAction(_ sender: Any) {
        delegate?.listTapped(indexPath: self.indexPath)
    }
    
    weak var delegate: MyPlayListTableViewCellDelegate?
    weak var playButtonDelegate: PlayListPlayButtonDelegate?
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    var key: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.playListImageView.layer.cornerRadius = 4
        self.playListNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.playListNameLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.playListCountLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playButton.setImage(DesignSystemAsset.Storage.play.image , for: .normal)
    }
}

extension MyPlayListTableViewCell {
    
    func update(model: PlayListEntity, isEditing: Bool, indexPath: IndexPath){
        
        self.key = model.key
        self.indexPath = indexPath

        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.image),version: model.image_version).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))])
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songlist.count)개"
        
        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        self.listSelectButton.isHidden = !isEditing
        self.playButton.isHidden = isEditing
        self.playButtonTrailingConstraint.constant = isEditing ? -24 : 20
    }
}
