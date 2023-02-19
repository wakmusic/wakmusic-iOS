//
//  NoticePopupViewController.swift
//  DesignSystem
//
//  Created by KTH on 2023/01/29.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import Utility
import PanModal
import SnapKit
import Then
import DesignSystem

public class NoticePopupViewController: UIViewController {

    private lazy var contentImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
    }
    
    private lazy var buttonContentView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 8
    }
    
    private lazy var nonShowButton = UIButton().then {
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        $0.titleLabel?.textColor = DesignSystemAsset.GrayColor.gray25.color
        $0.setTitle("다시보지 않기", for: .normal)
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray400.color
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(nonShowButtonAction), for: .touchUpInside)
    }

    private lazy var closeButton = UIButton().then {
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 18)
        $0.titleLabel?.textColor = DesignSystemAsset.GrayColor.gray25.color
        $0.setTitle("닫기", for: .normal)
        $0.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
        $0.layer.cornerRadius = 12
        $0.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
    }

    deinit {
        DEBUG_LOG("\(Self.self) Deinit")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
}

extension NoticePopupViewController {
    
    @objc
    private func nonShowButtonAction() {
        DEBUG_LOG("다시보지 않기") //서버 공지 api 확인 후 추가 작업
        dismiss(animated: true)
    }
    
    @objc
    private func closeButtonAction() {
        dismiss(animated: true)
    }
}

extension NoticePopupViewController {
    
    private func configureUI() {
        
        self.view.backgroundColor = .white
        
        self.view.addSubview(contentImageView)
        contentImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.width.height.equalTo(APP_WIDTH())
        }
        
        self.view.addSubview(buttonContentView)
        buttonContentView.snp.makeConstraints {
            $0.top.equalTo(contentImageView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(96)
        }

        buttonContentView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.left.equalTo(buttonContentView.snp.left).offset(20)
            $0.right.equalTo(buttonContentView.snp.right).offset(-20)
            $0.centerY.equalTo(buttonContentView.snp.centerY)
            $0.height.equalTo(56)
        }
        
        stackView.addArrangedSubview(nonShowButton)
        stackView.addArrangedSubview(closeButton)
    }
}

extension NoticePopupViewController: PanModalPresentable {

    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    public var panModalBackgroundColor: UIColor {
        return colorFromRGB(0x000000, alpha: 0.4)
    }

    public var panScrollable: UIScrollView? {
      return nil
    }

    public var longFormHeight: PanModalHeight {
        return PanModalHeight.contentHeight(APP_WIDTH() + 20 + 56 + 20)
     }

    public var cornerRadius: CGFloat {
        return 24.0
    }

    public var allowsExtendedPanScrolling: Bool {
        return true
    }

    public var showDragIndicator: Bool {
        return false
    }
}
