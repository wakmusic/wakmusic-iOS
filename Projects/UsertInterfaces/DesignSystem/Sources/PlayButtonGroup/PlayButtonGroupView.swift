//
//  PlayButtonGroupView.swift
//  DesignSystemTests
//
//  Created by yongbeomkwak on 2023/01/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

enum PlayEvent {
    case allPlay
    case shufflePlay
}

protocol PlayButtonGroupViewDelegate {
    func pressPlay(_ event:PlayEvent)
}

class PlayButtonGroupView: UIView {

    @IBOutlet weak var allPlayButton: UIButton!
    @IBOutlet weak var shufflePlayButton: UIButton!
    
    var delegate:PlayButtonGroupViewDelegate?
    
    
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
        let allPlayAttributedString = NSMutableAttributedString.init(string: "전체재생")
        
        allPlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                               .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                              range: NSRange(location: 0, length: allPlayAttributedString.string.count))

        allPlayButton.setImage(DesignSystemAsset.Chart.allPlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        allPlayButton.layer.cornerRadius = 8
        allPlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        allPlayButton.layer.borderWidth = 1
        allPlayButton.setAttributedTitle(allPlayAttributedString, for: .normal)
        
        let shufflePlayAttributedString = NSMutableAttributedString.init(string: "랜덤재생")
        
        shufflePlayAttributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                                                   .foregroundColor: DesignSystemAsset.GrayColor.gray900.color],
                                                  range: NSRange(location: 0, length: shufflePlayAttributedString.string.count))
        
        shufflePlayButton.setImage(DesignSystemAsset.Chart.shufflePlay.image.withRenderingMode(.alwaysOriginal), for: .normal)
        shufflePlayButton.layer.cornerRadius = 8
        shufflePlayButton.layer.borderColor = DesignSystemAsset.GrayColor.gray200.color.cgColor
        shufflePlayButton.layer.borderWidth = 1
        shufflePlayButton.setAttributedTitle(shufflePlayAttributedString, for: .normal)
        
    }
}
