//
//  ContainPlayListHeaderView.swift
//  CommonFeature
//
//  Created by yongbeomkwak on 2023/03/11.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem


public protocol ContainPlayListHeaderViewDelegate : AnyObject {
    
    func action()
    
}

class ContainPlayListHeaderView: UIView {

    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var buttonImageView: UIImageView!
    
    
    weak var delegate:ContainPlayListHeaderViewDelegate?
    
    
    @IBAction func buttonAction(_ sender: Any) {
        self.delegate?.action()
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
        if let view = Bundle.module.loadNibNamed("ContainPlayListHeaderView", owner: self,options: nil)!.first as? UIView{
            view.frame = self.bounds
            view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
            self.addSubview(view)
        }
        
        self.buttonImageView.image = DesignSystemAsset.Storage.storageNewPlaylistAdd.image
       
        let attr = NSMutableAttributedString(string: "새  플레이리스트에 담기",
                                             attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                          .foregroundColor:  DesignSystemAsset.GrayColor.gray900.color ])
 
        
        superView.layer.cornerRadius = 8
        superView.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        superView.layer.borderWidth = 1
        
        self.button.setAttributedTitle(attr, for: .normal)
        
        
    }

}
