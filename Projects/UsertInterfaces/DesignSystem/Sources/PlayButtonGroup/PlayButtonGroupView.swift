//
//  PlayButtonGroupView.swift
//  DesignSystemTests
//
//  Created by yongbeomkwak on 2023/01/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit

public enum PlayEvent {
    case allPlay
    case shufflePlay
}

public protocol PlayButtonGroupViewDelegate:AnyObject {
    
   func pressPlay(_ event:PlayEvent)
}

public class PlayButtonGroupView: UIView {

    @IBOutlet weak var allPlayButton: UIButton!
    @IBOutlet weak var shufflePlayButton: UIButton!
    
    public var delegate:PlayButtonGroupViewDelegate?
    
    
    @IBAction func pressAllPlay(_ sender: UIButton) {
        delegate?.pressPlay(.allPlay)
    }
    
    @IBAction func pressSufflePlay(_ sender: UIButton) {
        delegate?.pressPlay(.shufflePlay)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

}

extension PlayButtonGroupView {
    private func setupView(){
        
        guard let view = Bundle.module.loadNibNamed("PlayButtonGroupView", owner: self, options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.layoutIfNeeded()
        self.addSubview(view)
        
        
        view.backgroundColor = .clear
        let allPlayAttributedString = NSMutableAttributedString.init(string: "전체재생")
        
        allPlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                              range: NSRange(location: 0, length: allPlayAttributedString.string.count))
        
        allPlayButton.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        allPlayButton.layer.borderWidth = 1
       
        
        let shufflePlayAttributedString = NSMutableAttributedString.init(string: "랜덤재생")
        
        shufflePlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                   .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                                  range: NSRange(location: 0, length: shufflePlayAttributedString.string.count))
        
        shufflePlayButton.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        shufflePlayButton.layer.cornerRadius = 8
        shufflePlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        shufflePlayButton.layer.borderWidth = 1
        
        
        
               //여기 안으로 넣어보세요.
            allPlayButton.setAttributedTitle(allPlayAttributedString, for: .normal)
            shufflePlayButton.setAttributedTitle(shufflePlayAttributedString, for: .normal)
            view.layoutIfNeeded() //당장 UI 갱신해 : 사용 이유, 버튼 텍스트 깜빡거림 방지
        
        
    }
}
