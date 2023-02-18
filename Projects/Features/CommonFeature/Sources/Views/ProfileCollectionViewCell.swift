//
//  ProfileCollectionViewCell.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 2023/01/26.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import DesignSystem


public enum FanType: String{
    case panchi
    case ifari
    case dulgi
    case bat
    case segyun
    case gorani
    case jupock
    case ddong
}

public class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
    }
}

public extension ProfileCollectionViewCell{
    
    func update(_ model: ProfileResponseDTO){
        
        self.imageView.layer.cornerRadius = ((APP_WIDTH() - 70) / 4) / 2
        self.imageView.layer.borderColor = model.isSelected ? DesignSystemAsset.PrimaryColor.point.color.cgColor : UIColor.clear.cgColor
        self.imageView.layer.borderWidth = 3
        
        self.imageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchProfile(name: model.type.rawValue).toString),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
