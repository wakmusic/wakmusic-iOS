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
    
    @IBOutlet weak var moveTapButton: UIButton!
    @IBOutlet weak var numberOfSongLabel: UILabel!
    
    
    
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
        
        if let view = Bundle.module.loadNibNamed("EntireSectionHeader", owner: self,options: nil)!.first as? UIView{
            view.frame = self.bounds
            view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
            view.backgroundColor = .clear
            self.addSubview(view)
        }
        
       
        self.categoryLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.categoryLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        
        self.numberOfSongLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.numberOfSongLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
        
        
        
        
        
        
        
        //self.moveTapButton.setTitle("전체보기3", for: .normal)
        let title = moveTapButton.titleLabel!.text!
        let attrTitle = NSAttributedString(string: "전체보기", attributes: [
            NSAttributedString.Key.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
            .foregroundColor: DesignSystemAsset.GrayColor.gray900.color])
        
        moveTapButton.setAttributedTitle(attrTitle, for: UIControl.State.normal)
        
              
        
        self.moveTapButton.setImage(DesignSystemAsset.Search.searchArrowRight.image, for: .normal)
        

    }
    
    public func update(_ title:String,_ count:Int)
    {
        self.categoryLabel.text = title
        self.numberOfSongLabel.text = String(count)
    }
}
