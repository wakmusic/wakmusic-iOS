//
//  RecommendPlayListCell.swift
//  HomeFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem
import DomainModule
import Kingfisher

public class RecommendPlayListCell: UICollectionViewCell {
    
    @IBOutlet weak var titleStringLabel: UILabel!
    
    @IBOutlet weak var logoImageView: UIImageView!
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.backgroundColor = colorFromRGB(0xFCFCFD)
        
        self.logoImageView.layer.cornerRadius = self.logoImageView.frame.width / 2
    }
}

extension RecommendPlayListCell {
    
    func update(model: RecommendPlayListEntity) {
        
        
        //MARK: 폰트설정
        titleStringLabel.text = model.title
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        titleStringLabel.textColor = DesignSystemAsset.GrayColor.gray600.color
        
        
        logoImageView.kf.setImage(with: WMImageAPI.fetchRecommendPlayListWithRound(id: model.id,version: model.image_round_version).toURL
                                  ,placeholder: nil,
                                  options: [.transition(.fade(0.2))])
    }
}
