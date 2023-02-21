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
        
        
    }
    
    
    
}

extension MyPlayListTableViewCell {
    
    func update(model:SubPlayListEntity,isEditing:Bool)
    {
        

        self.playListImageView.kf.setImage(
            with: WMImageAPI.fetchPlayList(id: String(model.id)).toURL,
            placeholder: nil,
            options: [.transition(.fade(0.2))])

        self.isEdit = isEditing
        self.listButton.setImage(isEdit ?  DesignSystemAsset.Storage.move.image  : DesignSystemAsset.Storage.play.image , for: .normal)
        
        
        self.playListNameLabel.text = model.title
        self.playListCountLabel.text = "\(model.songs.count)개"
        
        
    }
    
}

public struct PlayListDTO{
    var playListName:String
    var numberOfSong:Int
}
