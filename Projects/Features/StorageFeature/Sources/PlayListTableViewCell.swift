//
//  PlayListTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/19.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

class PlayListTableViewCell: UITableViewCell {
    @IBOutlet weak var button:UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //update(SongInfoDTO(name: "라라라", artist: "ㅠㅡㅠㅡ", releaseDay: "12"), false)
       
    }
    
    

   

}

extension PlayListTableViewCell {
    func update(_ model: SongInfoDTO,_ isEidting:Bool) {

        self.backgroundColor = .clear
        
        albumImageView.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        titleLabel.text = "테스트"
        artistLabel.text = "테스트2"
        button.setImage( isEidting ? DesignSystemAsset.Storage.move.image :  DesignSystemAsset.Storage.play.image, for: .normal)
        

        
    }
}
