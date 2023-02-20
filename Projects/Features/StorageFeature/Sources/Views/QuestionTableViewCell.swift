//
//  QuestionTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/30.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import DomainModule

class QuestionTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        categoryLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        titleLabel.setLineSpacing(lineSpacing: 5)
    }


}

extension QuestionTableViewCell{
    public func update(model:QnaEntity){
            
        categoryLabel.text = model.category
        titleLabel.text = model.question
        expandImageView.image = model.isOpen ? DesignSystemAsset.Navigation.fold.image : DesignSystemAsset.Navigation.close.image

    }
    
    
}
