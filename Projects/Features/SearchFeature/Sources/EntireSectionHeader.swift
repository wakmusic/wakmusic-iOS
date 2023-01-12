//
//  EntireSectionHeader.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/12.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

class EntireSectionHeader: UIView {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberOfSongLabel: UILabel!
    @IBOutlet weak var moveTapButton: UIButton!
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

}

extension EntireSectionHeader {
    private func setupView(){
        self.categoryLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.categoryLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        self.numberOfSongLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.numberOfSongLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
        
        self.moveTapButton.setTitle("전체보기", for: .normal)
        self.moveTapButton.setTitleColor(DesignSystemAsset.GrayColor.gray900.color, for: .normal)
        self.moveTapButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.moveTapButton.setImage(DesignSystemAsset.Search.searchArrowRight.image, for: .normal)
        
        
        
    }
}
