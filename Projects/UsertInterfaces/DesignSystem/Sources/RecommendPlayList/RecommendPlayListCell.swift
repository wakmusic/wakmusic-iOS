//
//  RecommendPlayListCell.swift
//  HomeFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility

public class RecommendPlayListCell: UICollectionViewCell {
    
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.backgroundColor = colorFromRGB(0xFCFCFD)
    }
}

extension RecommendPlayListCell {
    
    func update(model: RecommendPlayListDTO) {
        
        //MARK: 폰트설정 
        titleStringLabel.text = model.title
        titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        titleStringLabel.textColor = DesignSystemAsset.GrayColor.gray600.color
        
        
        logoImageView.image = model.image
    }
}
