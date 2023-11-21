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
    
    private lazy var contentView = UIView()
    
    internal lazy var titleBarView = UIView()
    
    internal lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var titleCountStackView = UIStackView(arrangedSubviews: [titleLabel, countLabel]).then {
        $0.axis = .horizontal
        $0.distribution = .fill
        $0.spacing = 4
    }
    
    internal lazy var titleLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "재생목록"
        $0.setLineHeight(lineHeight: 24)
        $0.textAlignment = .center
    }
    
    internal lazy var countLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 18)
        $0.textColor = DesignSystemAsset.PrimaryColor.point.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.3)
        $0.text = ""
        $0.textAlignment = .center
        $0.setLineHeight(lineHeight: 28)
    }
    
    internal lazy var editButton = RectangleButton(type: .custom).then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: false)
        $0.setTitle("편집", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }
    
    internal lazy var playlistTableView = UITableView().then {
        $0.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 60
        $0.estimatedRowHeight = 60
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        $0.showsVerticalScrollIndicator = true
    }
    
    private lazy var blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .regular)
    }
    
    private lazy var homeIndicatorBackgroundView = UIView().then {
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    internal lazy var miniPlayerView = UIView().then {
        $0.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
    }
    
    internal lazy var miniPlayerContentView = UIView()
    
    internal lazy var miniPlayerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = (APP_WIDTH() < 375) ? 10 : 20
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
    
    internal lazy var repeatButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.miniPlay.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var prevButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var nextButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.nextOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var shuffleButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
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

private extension PlaylistView {
    private func configureUI() {
        self.backgroundColor = .clear // 가장 뒷배경
        self.configureSubViews()
        self.configureBackground()
        self.configureContent()
        self.configureTitleBar()
        self.configurePlaylist()
        self.configureBlur()
        self.configureMiniPlayer()
        self.configreHomeIndicatorBackgroundView()
    }
    
    private func configureSubViews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        contentView.addSubview(titleBarView)
        titleBarView.addSubview(closeButton)
        titleBarView.addSubview(titleCountStackView)
        titleBarView.addSubview(editButton)
        contentView.addSubview(playlistTableView)
        contentView.addSubview(blurEffectView)
        contentView.addSubview(miniPlayerView)
        contentView.addSubview(homeIndicatorBackgroundView)
        miniPlayerView.addSubview(miniPlayerContentView)
        miniPlayerContentView.addSubview(thumbnailImageView)
        miniPlayerContentView.addSubview(miniPlayerStackView)
        miniPlayerView.addSubview(totalPlayTimeView)
        totalPlayTimeView.addSubview(currentPlayTimeView)
        miniPlayerView.addSubview(repeatButton)
        miniPlayerView.addSubview(prevButton)
        miniPlayerView.addSubview(playButton)
        miniPlayerView.addSubview(nextButton)
        miniPlayerView.addSubview(shuffleButton)
    }
    
    private func configureBackground() {
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-SAFEAREA_BOTTOM_HEIGHT())
        }
    }
    
    private func configureContent() {
        contentView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Utility.STATUS_BAR_HEGHIT())
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
    }
    
    private func configureTitleBar() {
        titleBarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.left.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
        }
        
        titleCountStackView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        
        editButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalToSuperview()
        }
        
    }
    
    private func configurePlaylist() {
        playlistTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))
        playlistTableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        playlistTableView.snp.makeConstraints {
            $0.top.equalTo(titleBarView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func configureBlur() {
        blurEffectView.snp.makeConstraints {
            $0.height.equalTo(56 + SAFEAREA_BOTTOM_HEIGHT())
            $0.bottom.left.right.equalToSuperview()
        }
    }
    
    private func configureMiniPlayer() {
        miniPlayerView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-SAFEAREA_BOTTOM_HEIGHT())
        }
        
        totalPlayTimeView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.top.left.right.equalToSuperview()
        }
        
        currentPlayTimeView.snp.makeConstraints {
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0)
        }
        
        miniPlayerContentView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 16))
        }
        
        thumbnailImageView.snp.makeConstraints {
            let height = 40
            let width = height * 16 / 9
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        miniPlayerStackView.snp.makeConstraints {
            let spacing: CGFloat = (APP_WIDTH() < 375) ? 15 : 27
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(thumbnailImageView.snp.right).offset(spacing)
            $0.right.equalToSuperview()
        }
        
        miniPlayerStackView.addArrangedSubview(repeatButton)
        miniPlayerStackView.addArrangedSubview(prevButton)
        miniPlayerStackView.addArrangedSubview(playButton)
        miniPlayerStackView.addArrangedSubview(nextButton)
        miniPlayerStackView.addArrangedSubview(shuffleButton)
        
    }
    
    private func configreHomeIndicatorBackgroundView() {
        homeIndicatorBackgroundView.snp.makeConstraints {
            $0.height.equalTo(SAFEAREA_BOTTOM_HEIGHT())
            $0.left.right.bottom.equalToSuperview()
        }
    }
}
