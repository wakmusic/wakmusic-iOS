//
//  PlayListTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/19.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//
import UIKit
import DesignSystem
import DomainModule
import Utility

public protocol PlayListCellDelegate:AnyObject {
    func pressCell(index: Int)
}

class PlayListTableViewCell: UITableViewCell {
        
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var superButton: UIButton!
    
    public weak var cellDelegate: PlayListCellDelegate?
    public weak var playDelegate: PlayButtonDelegate?
    var index: Int!
    var model: SongEntity!

    @IBAction func selectedAction(_ sender: Any) {
        cellDelegate?.pressCell(index: index)
    }
    
    @IBAction func playOrEditAction(_ sender: UIButton) {
        playDelegate?.play(model: model)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.albumImageView.layer.cornerRadius = 4
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.artistLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playButton.setImage(DesignSystemAsset.Storage.play.image, for: .normal)
    }
}

extension PlayListTableViewCell {
    func update(_ model: SongEntity, _ isEditing: Bool, index:Int) {
      
        self.index = index
        self.isEditing = isEditing
        self.model = model
                
        self.albumImageView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        self.titleLabel.text =  model.title
        self.artistLabel.text = model.artist
        
        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        self.superButton.isHidden = !isEditing
        self.playButton.isHidden = isEditing
        self.playButtonTrailingConstraint.constant = isEditing ? -24 : 20
    }
}
