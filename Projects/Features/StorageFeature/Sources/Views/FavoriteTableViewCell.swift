//
//  FavoriteTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import CommonFeature

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    
    @IBOutlet weak var button: UIButton!
    
    var isEdit:Bool = false
    
    
    

    @IBAction func playAxtion(_ sender: UIButton) {
        
        if !isEdit{
            print("Play")
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = .clear
        
        albumImageView.layer.cornerRadius = 4

        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)

        
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.artistLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        
    }

}


extension FavoriteTableViewCell {
    
    public func update(_ model:SongInfoDTO,_ isEditing:Bool)
    {
        albumImageView.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        titleLabel.text =  model.name
        artistLabel.text = model.artist
        isEdit = isEditing
        
        button.setImage( isEditing ? DesignSystemAsset.Storage.move.image :  DesignSystemAsset.Storage.play.image, for: .normal)
    }
}
