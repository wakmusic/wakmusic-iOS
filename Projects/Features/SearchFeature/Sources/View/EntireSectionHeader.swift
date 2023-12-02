//
//  EntireSectionHeader.swift
//  SearchFeature
//
//  Created by yongbeomkwak on 2023/01/12.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem

protocol EntireSectionHeaderDelegate:AnyObject {
    func switchTapEvent(_ type:TabPosition)
}

class EntireSectionHeader: UIView {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var moveTabButton: UIButton!
    @IBOutlet weak var numberOfSongLabel: UILabel!
    @IBOutlet weak var allShowLabel: UILabel!
    @IBOutlet weak var allShowArrowImageView: UIImageView!
    
    weak var delegate: EntireSectionHeaderDelegate?
    var type: TabPosition = .all
    
    @IBAction func switchTabAction(_ sender: Any) {
        self.delegate?.switchTapEvent(type)
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

extension EntireSectionHeader {
    private func setupView(){
        if let view = Bundle.module.loadNibNamed("EntireSectionHeader", owner: self,options: nil)!.first as? UIView{
            view.frame = self.bounds
            view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
            view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
            self.addSubview(view)
        }
        configureUI()
    }
    
    public func update(_ type: (TabPosition, Int)) {
        self.type = type.0
        self.categoryLabel.text = type.0 == .song ? "노래" : type.0 == .artist ? "가수" : "조교"
        let numberOfSong: Int = type.1
        self.numberOfSongLabel.text = String(numberOfSong)
        self.allShowLabel.isHidden = numberOfSong <= 3
        self.allShowArrowImageView.isHidden = numberOfSong <= 3
        self.moveTabButton.isHidden = numberOfSong <= 3
    }
    
    private func configureUI() {
        self.categoryLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.categoryLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
        self.categoryLabel.setTextWithAttributes(kernValue: -0.5)
        
        self.numberOfSongLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        self.numberOfSongLabel.textColor = DesignSystemAsset.PrimaryColor.point.color
        self.numberOfSongLabel.setTextWithAttributes(kernValue: -0.5)

        let attrTitle = NSAttributedString(
            string: "전체보기",
            attributes: [.font: DesignSystemFontFamily.Pretendard.medium.font(size: 12),
                         .foregroundColor: DesignSystemAsset.GrayColor.gray900.color,
                         .kern: -0.5]
        )
        self.allShowLabel.attributedText = attrTitle
        self.allShowArrowImageView.image = DesignSystemAsset.Search.searchArrowRight.image
    }
}
