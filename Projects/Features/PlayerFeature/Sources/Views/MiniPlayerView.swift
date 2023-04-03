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

final class MiniPlayerView: UIView {
    private lazy var contentView: UIView = UIView().then {
        $0.backgroundColor = UIColor(hex: "#fcfdfd")
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
    
    internal lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailSmall.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    internal lazy var titleArtistLabelView: UIView = UIView()
    
    internal lazy var titleLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        $0.text = "리와인드(RE:WIND)"
        $0.setLineHeight(lineHeight: 24)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    internal lazy var artistLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.light, size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "이세계아이돌"
        $0.setLineHeight(lineHeight: 18)
        $0.lineBreakMode = .byTruncatingTail
    }
    
    internal lazy var playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.miniClose.image, for: .normal)
        $0.tintColor = .systemGray
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
        self.configureContent()
        self.configurePlayTime()
        self.configureThumbnail()
        self.configureTitleArtist()
        self.configureTitleLabel()
        self.configureArtistLabel()
        self.configurePlayButton()
        self.configureCloseButton()
    }
    
    private func configureSubViews() {
        self.addSubview(contentView)
        self.contentView.addSubview(totalPlayTimeView)
        self.totalPlayTimeView.addSubview(currentPlayTimeView)
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(titleArtistLabelView)
        self.titleArtistLabelView.addSubview(titleLabel)
        self.titleArtistLabelView.addSubview(artistLabel)
        self.contentView.addSubview(extendButton)
        self.contentView.addSubview(playButton)
        self.contentView.addSubview(closeButton)
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
    
    private func configureThumbnail() {
        let height = 40
        let width = height * 16 / 9
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
    }
    
    private func configureTitleArtist() {
        titleArtistLabelView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.bottom.equalToSuperview().offset(-7)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(8)
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
            $0.right.equalTo(closeButton.snp.left).offset(-20)
            $0.width.height.equalTo(32)
        }
    }
    
    private func configureCloseButton() {
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-16)
            $0.width.height.equalTo(32)
        }
    }
}
