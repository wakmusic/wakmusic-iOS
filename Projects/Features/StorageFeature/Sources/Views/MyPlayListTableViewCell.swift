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

public protocol MyPlayListTableViewCellDelegate: AnyObject {
    func buttonTapped(type: MyPlayListTableViewCellDelegateConstant)
}

public enum MyPlayListTableViewCellDelegateConstant {
    case listTapped(indexPath: IndexPath)
    case playTapped(key: String)
}

class MyPlayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playListImageView: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var listSelectButton: UIButton!
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        delegate?.buttonTapped(type: .playTapped(key: passToModel.1))
    }
    
    @IBAction func listSelectButtonAction(_ sender: Any) {
        delegate?.buttonTapped(type: .listTapped(indexPath: passToModel.0))
    }
    
    weak var delegate: MyPlayListTableViewCellDelegate?
    var passToModel: (IndexPath, String) = (IndexPath(row: 0, section: 0), "")

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
        
        self.passToModel = (indexPath, model.key)

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
