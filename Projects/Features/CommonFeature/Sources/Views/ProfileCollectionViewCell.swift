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


public enum FanType{
    case panzee
    case leaf
    case pigeon
    case bat
    case germ
    case gorani
    case fox
    case poopDog
    
}

extension FanType{
    var profileImage:UIImage{
        switch self {
        case .panzee:
            return DesignSystemAsset.Profile.profile0.image
        case .leaf:
            return DesignSystemAsset.Profile.profile1.image
        case .pigeon:
            return DesignSystemAsset.Profile.profile2.image
        case .bat:
            return DesignSystemAsset.Profile.profile3.image
        case .germ:
            return DesignSystemAsset.Profile.profile4.image
        case .gorani:
            return DesignSystemAsset.Profile.profile5.image
        case .fox:
            return DesignSystemAsset.Profile.profile6.image
        case .poopDog:
            return DesignSystemAsset.Profile.profile7.image
        }
    }
}

public class ProfileCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
}


public extension ProfileCollectionViewCell{
    
    func update(_ model:Model){
        self.imageView.image = model.type.profileImage
        
        
        self.imageView.layer.cornerRadius = ((APP_WIDTH() - 70) / 4) / 2
        self.imageView.layer.borderColor = model.isSelected ? DesignSystemAsset.PrimaryColor.point.color.cgColor : UIColor.clear.cgColor
        
        self.imageView.layer.borderWidth = 3
        
    }
    
}
