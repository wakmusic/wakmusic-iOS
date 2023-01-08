//
//  WarningView.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

class WarningView: UIView {

    @IBOutlet weak var warningLabelView: UILabel!
    @IBOutlet weak var warningImageView: UIImageView!
    var text:String = ""
    {
        didSet{
            warningLabelView.text = text
        }
    }
    
    
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
        if let view = Bundle.module.loadNibNamed("WarningView", owner: self,options: nil)!.first as? UIView{
            view.frame = self.bounds
            view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
            view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color //헤더 영역 흰 색 방지
            self.addSubview(view)
            
        }
        
        warningImageView.image = DesignSystemAsset.Search.warning.image
        
        
        
        
    }

}
