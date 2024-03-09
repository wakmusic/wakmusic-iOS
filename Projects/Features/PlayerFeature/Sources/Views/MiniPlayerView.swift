//
//  MiniPlayerView.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/12.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import MarqueeLabel
import SnapKit
import SwiftUI
import Then
import UIKit
import Utility

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

    internal lazy var titleArtistStackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel])
        .then {
            $0.axis = .vertical
            $0.distribution = .fill
        }

    lazy var titleLabel = WMFlowLabel(
        text: "제목",
        textColor: DesignSystemAsset.GrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5,
        leadingBuffer: 0,
        trailingBuffer: 35,
        animationDelay: 1,
        animationSpeed: 30,
        fadeLength: 3
    )

    lazy var artistLabel = WMFlowLabel(
        text: "아티스트",
        textColor: DesignSystemAsset.GrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5,
        leadingBuffer: 0,
        trailingBuffer: 20,
        animationDelay: 1,
        animationSpeed: 30,
        fadeLength: 3
    )

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
        self.configurePlayButton()
        self.configureNextButton()
        self.configurePlaylistButton()
    }

    private func configureSubViews() {
        self.addSubview(blurEffectView)
        self.addSubview(contentView)
        self.contentView.addSubview(totalPlayTimeView)
        self.totalPlayTimeView.addSubview(currentPlayTimeView)
        self.contentView.addSubview(titleArtistStackView)
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
        titleArtistStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(7)
            $0.bottom.equalToSuperview().offset(-7)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalTo(playButton.snp.left).offset(-16)
        }
    }

    private func configurePlayButton() {
        playButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(nextButton.snp.left).offset(-16)
            $0.width.height.equalTo(32)
        }
    }

    private func configureNextButton() {
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(playlistButton.snp.left).offset(-16)
            $0.width.height.equalTo(32)
        }
    }

    private func configurePlaylistButton() {
        playlistButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-20)
            $0.width.height.equalTo(32)
        }
    }
}
