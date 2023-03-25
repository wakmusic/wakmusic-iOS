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
    
    func pressCell(index:Int)
}

class PlayListTableViewCell: UITableViewCell {
    
    
    
    public weak var cellDelegate:PlayListCellDelegate?
    public weak var playDelegate:PlayButtonDelegate?
    var index:Int!
    var model:SongEntity!
    @IBOutlet weak var playButton:UIButton!
    @IBOutlet weak var playButtonTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var superButton: UIButton!
    
    @IBAction func selectedAction(_ sender: Any) {
        
        if isEditing {
            cellDelegate?.pressCell(index: index)
        }
  
    }
    @IBAction func playOrEditAction(_ sender: UIButton) {
        
        playDelegate?.play(model: model)
        
    }
        
    override var isEditing: Bool {
        didSet {
            updatePlayingState()
        }
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
    func update(_ model: SongEntity,_ isEditing:Bool,index:Int) {
        
      
        
        self.index = index
        self.isEditing = isEditing
        self.model = model
        
        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        
        albumImageView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        titleLabel.text =  model.title
        artistLabel.text = model.artist
        
       
    }
    
    private func updatePlayingState() {
        if self.isEditing {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 오른쪽으로 사라지는 애니메이션
                guard let self else { return }
                self.playButton.alpha = 0
                self.playButton.transform = CGAffineTransform(translationX: 100, y: 0)
                self.playButtonTrailingConstraint.constant = -24
                self.layoutIfNeeded()

            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.playButton.isHidden = true
            })
        } else {
            self.playButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 다시 나타나는 애니메이션
                guard let self else { return }
                self.playButton.alpha = 1
                self.playButton.transform = .identity
                self.playButton.isHidden = false
                self.playButtonTrailingConstraint.constant = 20
                self.layoutIfNeeded()

            }, completion: { _ in
            })
        }
    }
}
