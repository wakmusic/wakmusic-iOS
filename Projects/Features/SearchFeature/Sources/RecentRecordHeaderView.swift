//
//  RecentRecordHeaderView.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/08.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

class RecentRecordHeaderView: UIView {

    
    
    
    @IBOutlet weak var removeAllButton: UIButton!
    @IBOutlet weak var recentLabel: UILabel!
    override init(frame: CGRect) { //코드쪽에서 생성 시 호출
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder:NSCoder) //StoryBoard에서 호출됨
    {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    
    private func setupView()
    {
        if let view = Bundle.module.loadNibNamed("RecentRecordHeaderView", owner: self,options: nil)!.first as? UIView{
            view.frame = self.bounds
            view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
            view.backgroundColor = .clear
            self.addSubview(view)
        }
        
        self.recentLabel.text = "최근 검색어"
        self.recentLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 16)
        self.recentLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.removeAllButton.setTitle("전체삭제", for: .normal)
        self.removeAllButton.setTitleColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        self.removeAllButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        
       
        
        
    }
    
    
    
    
    
    
    
    
    
    

}
