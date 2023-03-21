//
//  SongListCellView.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import DomainModule
import Kingfisher

public class SongListCell: UITableViewCell {

    @IBOutlet weak var albumImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    

    
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = .clear
        
        albumImageView.layer.cornerRadius = 4

    }
}

public extension SongListCell {
    
    static func getCellHeight() -> CGFloat {
        
        let base: CGFloat = 10 + 10
        let width: CGFloat = (72.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = (width * 40.0) / 72.0

        return base + height
    }
    
    func update(_ model:SongEntity) {
        
        self.contentView.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear
        
        albumImageView.kf.setImage(with: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toURL,placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,options: [.transition(.fade(0.2))])
        
        
        self.titleLabel.text = model.title
        self.artistLabel.text = model.artist
        self.releaseDateLabel.text = model.date
        
        
        self.titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        self.artistLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        self.releaseDateLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        
        self.titleLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.artistLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.releaseDateLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        
    }
}


public struct SongInfoDTO {
    public var name:String
    public var artist:String
    public var releaseDay:String
    
    public init(name: String, artist: String, releaseDay: String) {
        self.name = name
        self.artist = artist
        self.releaseDay = releaseDay
    }
}
