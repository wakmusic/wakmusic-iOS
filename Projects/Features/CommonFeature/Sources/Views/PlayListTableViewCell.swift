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

public protocol PlayListCellDelegate: AnyObject {
    func buttonTapped(type: PlayListCellDelegateConstant)
}

public enum PlayListCellDelegateConstant {
    case listTapped(index: Int)
    case playTapped(song: SongEntity)
}

class PlayListTableViewCell: UITableViewCell {
        
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var superButton: UIButton!
    
    public weak var delegate: PlayListCellDelegate?
    var passToModel: (Int, SongEntity?) = (0, nil)

    @IBAction func selectedAction(_ sender: Any) {
        delegate?.buttonTapped(type: .listTapped(index: passToModel.0))
    }
    
    @IBAction func playOrEditAction(_ sender: UIButton) {
        guard let song = self.passToModel.1 else { return }
        delegate?.buttonTapped(type: .playTapped(song: song))
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
      
        self.passToModel = (index, model)
                
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
