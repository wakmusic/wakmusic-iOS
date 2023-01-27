//
//  MyPlayListHeaderView.swift
//  StorageFeature
//
//  Created by yongbeomkwak on 2023/01/27.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

enum MyPlayListHeaderButtionType {
    case create
    case load
}

protocol MyPlayListHeaderViewDelegate{
    
    func action(_ tpye:MyPlayListHeaderButtionType )
    
}


class MyPlayListHeaderView: UIView {
    
    
    @IBOutlet weak var createPlayListImageView: UIImageView!
    @IBOutlet weak var createPlayListButton: UIButton!
    

    @IBOutlet weak var loadPlayListImageView: UIImageView!
    @IBOutlet weak var loadPlayListButton: UIButton!
    var delegate:MyPlayListHeaderViewDelegate?
    
    
    
    @IBAction func createPlayListAction(_ sender: UIButton) {
        delegate?.action(.create)
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
            view.backgroundColor = .clear
            self.addSubview(view)
        }
        
        self.createPlayListImageView.image = DesignSystemAsset.Storage.storageNewPlaylistAdd.image
        self.loadPlayListImageView.image = DesignSystemAsset.Storage.share.image
        
        let createAttr = NSMutableAttributedString(string: "플레이리스트 만들기",
                                             attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                          .foregroundColor:  DesignSystemAsset.GrayColor.gray900.color ])
        let loadAttr = NSMutableAttributedString(string: "플레이리스트 가져오기",
                                             attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                          .foregroundColor:  DesignSystemAsset.GrayColor.gray900.color ])
        
        
        for btn in [self.createPlayListButton,self.loadPlayListButton] {
            
            btn?.layer.cornerRadius = 8
            btn?.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
            btn?.layer.borderWidth = 1
        }
        
        
        
        
        self.createPlayListButton.setAttributedTitle(createAttr, for: .normal)
        self.loadPlayListButton.setAttributedTitle(loadAttr, for: .normal)
        
        
    
        
       
        
        
    }
}
