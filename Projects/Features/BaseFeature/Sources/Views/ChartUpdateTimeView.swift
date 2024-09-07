//
//  PlayButtonForNewSongsView.swift
//  CommonFeature
//
//  Created by KTH on 2023/11/16.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import RxRelay
import RxSwift
import SnapKit
import Then
import UIKit

public final class ChartUpdateTimeView: UIView {
    private let updateTimeLabel = WMLabel(
        text: "업데이트",
        textColor: DesignSystemAsset.GrayColor.gray600.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    )

    private let updateTimeImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.check.image
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }

    public func setUpdateTime(updateTime: String) {
        updateTimeLabel.text = updateTime
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
