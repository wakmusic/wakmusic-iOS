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
    
    var isEdit:Bool = false
    
    @IBAction func buttonAction(_ sender: UIButton) {
        
        if(!isEdit)
        {
            print("Play")
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
    
    func update(model:PlayListEntity,isEditing:Bool)
    {
        

        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.image),version: model.image_version).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))])

        self.isEdit = isEditing
           
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songlist.count)개"
        
        
        updatePlayingState(isEditing: isEditing)
        self.listButton.isHidden = isEdit
    }
    
    private func updatePlayingState(isEditing:Bool) {
        if isEditing {
            UIView.animate(withDuration: 0.3) { [weak self] in // 오른쪽으로 사라지는 애니메이션
                guard let self else { return }
                self.listButton.alpha = 0
                self.listButton.transform = CGAffineTransform(translationX: 100, y: 0)
                
            }
        } else {
            UIView.animate(withDuration: 0.3) { [weak self] in // 다시 돌아오는 애니메이션
                guard let self else { return }
                self.listButton.alpha = 1
                self.listButton.transform = .identity
            }
            
        }
    }
    
}

