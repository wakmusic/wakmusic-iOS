//
//  MiniPlayerView.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/12.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SwiftUI
import Utility
import DesignSystem
import SnapKit
import Then
import MarqueeLabel

final class MiniPlayerView: UIView {
    private lazy var blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .regular)
    }
    
    private lazy var contentView: UIView = UIView().then {
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    internal lazy var extendButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    internal lazy var totalPlayTimeView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray300.color
    }
    internal lazy var currentPlayTimeView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColor.point.color
    }
    
    internal lazy var titleArtistLabelView: UIView = UIView()
    
    internal lazy var titleLabel = MarqueeLabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        $0.text = "리와인드(RE:WIND)"
        $0.setLineHeight(lineHeight: 24)
        $0.lineBreakMode = .byTruncatingTail
        $0.leadingBuffer = 0
        $0.trailingBuffer = 35
        $0.fadeLength = 3
        $0.animationDelay = 1
        $0.speed = .rate(30)
    }
    
    internal lazy var artistLabel = MarqueeLabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.light, size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "이세계아이돌"
        $0.setLineHeight(lineHeight: 18)
        $0.lineBreakMode = .byTruncatingTail
        $0.leadingBuffer = 0
        $0.trailingBuffer = 20
        $0.fadeLength = 3
        $0.animationDelay = 1
        $0.speed = .rate(30)
    }
    
    internal lazy var playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var nextButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.nextOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.miniClose.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var playlistButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.playList.image, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
}

private extension MiniPlayerView {
    private func configureUI() {
        self.configureSubViews()
        self.configureBlur()
        self.configureContent()
        self.configurePlayTime()
        self.configureTitleArtist()
        self.configureTitleLabel()
        self.configureArtistLabel()
        self.configurePlayButton()
        self.configureNextButton()
        self.configurePlaylistButton()
    }
    
    private func configureSubViews() {
        self.addSubview(blurEffectView)
        self.addSubview(contentView)
        self.contentView.addSubview(totalPlayTimeView)
        self.totalPlayTimeView.addSubview(currentPlayTimeView)
        self.contentView.addSubview(titleArtistLabelView)
        self.titleArtistLabelView.addSubview(titleLabel)
        self.titleArtistLabelView.addSubview(artistLabel)
        self.contentView.addSubview(extendButton)
        self.contentView.addSubview(playButton)
        self.contentView.addSubview(nextButton)
        self.contentView.addSubview(playlistButton)
    }
    
    private func configureBlur() {
        blurEffectView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
    }
    
    private func configureContent() {
        contentView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        extendButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func configurePlayTime() {
        totalPlayTimeView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(1)
        }
        currentPlayTimeView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(totalPlayTimeView.snp.width).multipliedBy(0.1)
        }
    }
    
    private func configureTitleArtist() {
        titleArtistLabelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.bottom.equalToSuperview().offset(-7)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(playButton.snp.left).offset(-12)
        }
    }
    
    private func configureTitleLabel() {
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
        }
    }
    private func configureArtistLabel() {
        artistLabel.snp.makeConstraints {
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    private func configurePlayButton() {
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(nextButton.snp.left).offset(-20)
            $0.width.height.equalTo(32)
        }
    }
    
    private func configureNextButton() {
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(playlistButton.snp.left).offset(-20)
            $0.width.height.equalTo(32)
        }
    }
    
    private func configurePlaylistButton() {
        playlistButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(32)
        }
    }
}
