//
//  NickNameInfoTableViewCell.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/03/10.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

class NickNameInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var checkImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        descriptionLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
    }


}

extension NickNameInfoTableViewCell {
    
    public func update(model:NickNameInfo){
            
        
        descriptionLabel.font = model.check ? DesignSystemFontFamily.Pretendard.medium.font(size: 18) : DesignSystemFontFamily.Pretendard.light.font(size: 18)
        
        descriptionLabel.text = model.description
        
        checkImageView.image = model.check ? DesignSystemAsset.Storage.checkBox.image : nil
        

    }
    
}
