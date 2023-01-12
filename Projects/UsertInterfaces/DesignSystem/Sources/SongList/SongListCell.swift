//
//  SongListCellView.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility

public class SongListCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    

    
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
    }
}

public extension SongListCell {
    
    static func getCellHeight() -> CGFloat {
        
        let base: CGFloat = 10 + 10
        let width: CGFloat = (72.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = (width * 40.0) / 72.0

        return base + height
    }
    
    func update(_ song:SongInfoDTO) {
        
        albumImageView.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        albumImageView.layer.cornerRadius = 8
        albumImageView.layer.borderColor = colorFromRGB(0xE4E7EC).cgColor
        albumImageView.layer.borderWidth = 1
        
        self.titleLabel.text = song.name
        self.artistLabel.text = song.artist
        self.releaseDateLabel.text = song.releaseDay
        
    }
}

public struct SongInfoDTO {
    var name:String
    var artist:String
    var releaseDay:String
    
    public init(name: String, artist: String, releaseDay: String) {
        self.name = name
        self.artist = artist
        self.releaseDay = releaseDay
    }
}

