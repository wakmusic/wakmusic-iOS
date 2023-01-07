//
//  RecommendPlayListCell.swift
//  HomeFeature
//
//  Created by KTH on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility

class RecommendPlayListCell: UICollectionViewCell {
    
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.backgroundColor = colorFromRGB(0xFCFCFD)
    }
}

extension RecommendPlayListCell {
    
    func update(model: RecommendPlayListDTO) {
        
        titleStringLabel.text = model.title
        logoImageView.image = model.image
    }
}
