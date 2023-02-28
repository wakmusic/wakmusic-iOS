//
//  PlaylistView.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import Foundation
import UIKit
import Utility
import DesignSystem
import SnapKit
import Then

public final class PlaylistView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    internal lazy var dismissButton = UIButton().then {
        $0.setTitle("뒤로가기", for: .normal)
        $0.setBackgroundColor(UIColor.blue, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension PlaylistView {
    private func configureUI() {
        self.configureSubViews()
        self.configureBackground()
        dismissButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(50)
        }
    }
    
    private func configureSubViews() {
        self.addSubview(backgroundView)
        self.addSubview(dismissButton)
    }
    
    private func configureBackground() {
        backgroundView.snp.makeConstraints {
            $0.top.bottom.left.right.equalToSuperview()
        }
    }
}
