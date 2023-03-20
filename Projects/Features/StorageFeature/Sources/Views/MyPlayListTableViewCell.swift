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

class MyPlayListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playListImageView: UIImageView!
    
    @IBOutlet weak var playListNameLabel: UILabel!
    
    @IBOutlet weak var playListCountLabel: UILabel!
    
    @IBOutlet weak var listButton: UIButton!
    @IBOutlet weak var listButtonTrailingConstraint: NSLayoutConstraint!
        
    @IBAction func buttonAction(_ sender: UIButton) {
        
    }
    
    override var isEditing: Bool {
        didSet {
            updatePlayingState()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.backgroundColor = .clear
        
       
        self.playListImageView.layer.cornerRadius = 4
        self.playListNameLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.playListNameLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.playListCountLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.listButton.setImage(DesignSystemAsset.Storage.play.image , for: .normal)
    }
}

extension MyPlayListTableViewCell {
    
    func update(model:PlayListEntity,isEditing:Bool){
        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.image),version: model.image_version).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))])
           
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songlist.count)개"
    }
    
    private func updatePlayingState() {
        if self.isEditing {
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 오른쪽으로 사라지는 애니메이션
                guard let self else { return }
                self.listButton.alpha = 0
                self.listButton.transform = CGAffineTransform(translationX: 100, y: 0)
                self.listButtonTrailingConstraint.constant = -24
                self.layoutIfNeeded()

            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.listButton.isHidden = true
            })
        } else {
            self.listButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: { [weak self] in // 다시 나타나는 애니메이ㄴ
                guard let self else { return }
                self.listButton.alpha = 1
                self.listButton.transform = .identity
                self.listButton.isHidden = false
                self.listButtonTrailingConstraint.constant = 20
                self.layoutIfNeeded()

            }, completion: { _ in
            })
        }
    }

}

