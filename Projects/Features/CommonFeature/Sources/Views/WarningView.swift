//
//  WarningView.swift
//  Created by yongbeomkwak on 2023/01/07.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//
import UIKit
import DesignSystem

public class WarningView: UIView {
    @IBOutlet weak var superView: UIView!
    @IBOutlet weak var warningLabelView: UILabel!
    @IBOutlet weak var warningImageView: UIImageView!
    
    public var text: String = "" {
        didSet{
            warningLabelView.text = text
        }
    }
    
    public override init(frame: CGRect) { // 코드쪽에서 생성 시 호출
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) { // StoryBoard에서 호출됨
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    private func setupView(){
        guard let view = Bundle.module.loadNibNamed("Warning", owner: self,options: nil)?.first as? UIView else { return }
        view.frame = self.bounds
        view.layoutIfNeeded() //드로우 사이클을 호출할 때 쓰임
        view.backgroundColor = .clear //헤더 영역 흰 색 방지
        self.superView.backgroundColor = .clear
        self.addSubview(view)
        configureUI()
    }
}

extension WarningView {
    private func configureUI() {
        warningImageView.image = DesignSystemAsset.Search.warning.image
        warningLabelView.textColor = DesignSystemAsset.GrayColor.gray900.color
        warningLabelView.setTextWithAttributes(kernValue: -0.5)
        warningLabelView.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
    }
}
