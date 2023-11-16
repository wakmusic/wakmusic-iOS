//
//  PlayButtonForNewSongsView.swift
//  CommonFeature
//
//  Created by KTH on 2023/11/16.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import Then

public final class ChartUpdateTimeView: UIView {
    private let updateTimeLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray600.color
    }
    private let updateTimeImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.check.image
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    public func setUpdateTime(updateTime: String) {
        let attributedString = NSMutableAttributedString(string: updateTime)
        attributedString.addAttributes([.font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                                        .foregroundColor: DesignSystemAsset.GrayColor.gray600.color,
                                        .kern: -0.5],
                                       range: NSRange(location: 0, length: attributedString.string.count))
        updateTimeLabel.attributedText = attributedString
    }
}

extension ChartUpdateTimeView {
    private func setupView() {
        self.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        
        [updateTimeImageView, updateTimeLabel].forEach { self.addSubview($0) }
        
        updateTimeImageView.snp.makeConstraints {
            $0.top.equalTo(1)
            $0.width.height.equalTo(16)
            $0.leading.equalTo(20)
        }
        
        updateTimeLabel.snp.makeConstraints {
            $0.top.equalTo(0)
            $0.height.equalTo(18)
            $0.leading.equalTo(updateTimeImageView.snp.trailing).offset(2)
        }
    }
}
