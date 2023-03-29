//
//  MyPlayListHeaderView.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import CommonFeature


public protocol MyPlayListHeaderViewDelegate : AnyObject {
    
    func action(_ type:PurposeType )
    
}


class MyPlayListHeaderView: UIView {
    
    
    @IBOutlet weak var createPlayListImageView: UIImageView!
    @IBOutlet weak var createPlayListButton: UIButton!
    @IBOutlet weak var createSuperView: UIView!
    
    
    
    @IBOutlet weak var loadSuperView: UIView!
    @IBOutlet weak var loadPlayListImageView: UIImageView!
    @IBOutlet weak var loadPlayListButton: UIButton!
    
    
    
    
    weak var delegate:MyPlayListHeaderViewDelegate?
    
    
    
    @IBAction func createPlayListAction(_ sender: UIButton) {
        delegate?.action(.creation)
    }
    
    
    
    @IBAction func loadPlayListAction(_ sender: UIButton) {
        delegate?.action(.load)
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
        if let view = Bundle.module.loadNibNamed("MyPlayListHeader", owner: self,options: nil)!.first as? UIView{
            view.frame = self.bounds
            view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
          //  view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
            self.addSubview(view)
        }
        
        
        self.createPlayListImageView.image = DesignSystemAsset.Storage.storageNewPlaylistAdd.image
        self.loadPlayListImageView.image = DesignSystemAsset.Storage.share.image
        
        let createAttr = NSMutableAttributedString(string: "리스트 만들기",
                                             attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                          .foregroundColor:  DesignSystemAsset.GrayColor.gray900.color ])
        let loadAttr = NSMutableAttributedString(string: "리스트 가져오기",
                                             attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                          .foregroundColor:  DesignSystemAsset.GrayColor.gray900.color ])
        
        
        for view in [self.createSuperView,self.loadSuperView] {
            
            view?.backgroundColor = .white.withAlphaComponent(0.4)
            view?.layer.cornerRadius = 8
            view?.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
            view?.layer.borderWidth = 1
        }
        
        
    
        
        self.createPlayListButton.setAttributedTitle(createAttr, for: .normal)
        self.loadPlayListButton.setAttributedTitle(loadAttr, for: .normal)
        
        
    
        
       
        
        
    }
}
