//
//  PlayerView.swift
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

public final class PlayerView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    private lazy var blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .regular)
    }
    
    internal lazy var backgroundImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        $0.contentMode = .scaleToFill
        $0.layer.opacity = 0.6
        $0.clipsToBounds = true
    }
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var titleBarView: UIView = UIView()
    
    internal lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var titleLabel = MarqueeLabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "리와인드(RE:WIND)"
        $0.setLineHeight(lineHeight: 24)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .center
        $0.leadingBuffer = 0
        $0.trailingBuffer = 35
        $0.fadeLength = 3
        $0.animationDelay = 1
        $0.speed = .rate(30)
    }
    
    internal lazy var artistLabel = MarqueeLabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.alpha = 0.6
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.2)
        $0.text = "이세계아이돌"
        $0.setLineHeight(lineHeight: 20)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .center
        $0.leadingBuffer = 0
        $0.trailingBuffer = 20
        $0.fadeLength = 3
        $0.animationDelay = 1
        $0.speed = .rate(30)
    }
    
    internal lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    internal lazy var lyricsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(LyricsTableViewCell.self, forCellReuseIdentifier: LyricsTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 24
        $0.estimatedRowHeight = 24
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        $0.showsVerticalScrollIndicator = false
    }
    
    internal lazy var playTimeSlider = CustomSlider().then {
        let circleSize: CGFloat = 8.0
        let circleImage: UIImage? = makeCircleWith(size: CGSize(width: circleSize,
                                                                height: circleSize),
                                                   color: colorFromRGB(0x08DEF7),
                                                   padding: 20)
        $0.layer.cornerRadius = 1
        $0.setThumbImage(circleImage, for: .normal)
        $0.setThumbImage(circleImage, for: .highlighted)
        $0.maximumTrackTintColor = DesignSystemAsset.GrayColor.gray300.color // 슬라이더 안지나갔을때 컬러 값
        $0.minimumTrackTintColor = DesignSystemAsset.PrimaryColor.point.color
    }
    
    private lazy var playTimeView: UIView = UIView()
    
    internal lazy var currentPlayTimeLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.textColor = DesignSystemAsset.PrimaryColor.point.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "0:30"
    }
    
    internal lazy var totalPlayTimeLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray400.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "4:34"
    }
    
    private lazy var buttonBarView: UIView = UIView()
    
    internal lazy var playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
        $0.tintColor = .systemGray
        $0.layer.shadowColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 8)
        $0.layer.shadowRadius = 40
    }
    
    internal lazy var prevButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var nextButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.nextOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var repeatButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    internal lazy var shuffleButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var bottomBarView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var bottomBarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    internal lazy var likeButton = LikeButton().then {
        $0.titleLabel.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.isLiked = false
    }
    
    internal lazy var viewsView = VerticalImageButton().then {
        $0.image = DesignSystemAsset.Player.views.image
        $0.titleLabel.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.titleLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
    }
    
    internal lazy var addPlayistButton = VerticalImageButton().then {
        $0.image = DesignSystemAsset.Player.playerMusicAdd.image
        $0.title = "노래담기"
        $0.titleLabel.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.titleLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
    }
    
    internal lazy var playistButton = VerticalImageButton().then {
        $0.image = DesignSystemAsset.Player.playList.image
        $0.title = "재생목록"
        $0.titleLabel.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.titleLabel.textColor = DesignSystemAsset.GrayColor.gray400.color
    }
    
    
    private var firstSpacing: CGFloat = 0
    private var secondSpacing: CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

private extension PlayerView {
    private func configureUI() {
        self.backgroundColor = .white
        self.updateSpacing()
        self.configureSubViews()
        self.configureBackground()
        self.configureContent()
        self.configureTitleBar()
        self.configureThumbnail()
        self.configureLyrics()
        self.configurePlayTimeSlider()
        self.configurePlayTime()
        self.configureButtonBar()
        self.configureBottomBar()
    }
    
    private func configureSubViews() {
        self.addSubview(backgroundView)
        self.addSubview(contentView)
        
        self.backgroundView.addSubview(backgroundImageView)
        self.backgroundImageView.addSubview(blurEffectView)
        
        self.contentView.addSubview(titleBarView)
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(lyricsTableView)
        self.contentView.addSubview(playTimeSlider)
        self.contentView.addSubview(playTimeView)
        self.contentView.addSubview(buttonBarView)
        self.contentView.addSubview(bottomBarView)
        
        self.titleBarView.addSubview(closeButton)
        self.titleBarView.addSubview(titleLabel)
        self.titleBarView.addSubview(artistLabel)
        
        self.playTimeView.addSubview(currentPlayTimeLabel)
        self.playTimeView.addSubview(totalPlayTimeLabel)
        
        self.buttonBarView.addSubview(playButton)
        self.buttonBarView.addSubview(prevButton)
        self.buttonBarView.addSubview(nextButton)
        self.buttonBarView.addSubview(repeatButton)
        self.buttonBarView.addSubview(shuffleButton)
        
        self.bottomBarView.addSubview(bottomBarStackView)
        
        self.bottomBarStackView.addArrangedSubview(likeButton)
        self.bottomBarStackView.addArrangedSubview(viewsView)
        self.bottomBarStackView.addArrangedSubview(addPlayistButton)
        self.bottomBarStackView.addArrangedSubview(playistButton)
        
    }
    
    private func configureBackground() {
        let safeAreaBottomInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        backgroundView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-safeAreaBottomInset)
        }
        backgroundImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(thumbnailImageView.snp.bottom).offset(-36)
        }
        blurEffectView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    private func configureContent() {
        let safeAreaBottomInset: CGFloat = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
        contentView.snp.makeConstraints {
            $0.top.equalTo(Utility.STATUS_BAR_HEGHIT())
            $0.bottom.equalToSuperview().offset(-safeAreaBottomInset)
            $0.horizontalEdges.equalToSuperview()
        }
    }
    private func configureTitleBar() {
        titleBarView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(48)
        }
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(20)
            $0.width.height.equalTo(48)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(2)
            $0.left.equalTo(closeButton.snp.right)
            $0.right.equalToSuperview().offset(-68)
        }
        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.left.equalTo(closeButton.snp.right)
            $0.right.equalToSuperview().offset(-68)
        }
    }
    private func configureThumbnail() {
        let width = Utility.APP_WIDTH() - 25 - 25
        let height = width * 9 / 16
        thumbnailImageView.snp.makeConstraints {
            $0.top.equalTo(titleBarView.snp.bottom).offset(firstSpacing)
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        thumbnailImageView.backgroundColor = .white
    }
    private func configureLyrics() {
        let isNotch = Utility.APP_HEIGHT() >= 812 // iPhone X 이상 기종
        self.lyricsTableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: lyricsTableView.frame.width, height: isNotch ? 48 : 24))
        self.lyricsTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: lyricsTableView.frame.width, height: isNotch ? 48 : 24))
        lyricsTableView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(firstSpacing)
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(LyricsTableViewCell.lyricMaxWidth)
            $0.height.equalTo(isNotch ? 120 : 72)
        }
    }
    private func configurePlayTimeSlider() {
        playTimeSlider.snp.makeConstraints {
            $0.top.equalTo(lyricsTableView.snp.bottom).offset(firstSpacing)
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
        }
    }
    private func configurePlayTime() {
        playTimeView.snp.makeConstraints {
            $0.top.equalTo(playTimeSlider.snp.bottom).offset(-16)
            $0.horizontalEdges.equalTo(playTimeSlider.snp.horizontalEdges)
            $0.height.equalTo(18)
        }
        currentPlayTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        totalPlayTimeLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
    private func configureButtonBar() {
        buttonBarView.snp.makeConstraints {
            $0.top.equalTo(playTimeView.snp.bottom).offset(secondSpacing)
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
            $0.height.equalTo(80)
        }
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(80)
        }
        prevButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(playButton.snp.left).offset(-24)
            $0.width.height.equalTo(48)
        }
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(playButton.snp.right).offset(24)
            $0.width.height.equalTo(48)
        }
        repeatButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(prevButton.snp.left).offset(-24)
            $0.width.height.equalTo(48)
        }
        shuffleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nextButton.snp.right).offset(24)
            $0.width.height.equalTo(48)
        }
    }
    private func configureBottomBar() {
        bottomBarView.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalToSuperview()
            $0.height.equalTo(56)
        }
        bottomBarStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(22)
        }
    }
    
    private func updateSpacing() {
        let x = specialValue()
        firstSpacing = x * 4 + 4
        secondSpacing = x * 4 - 4
    }
    
    private func specialValue() -> CGFloat {
        let window: UIWindow? = UIApplication.shared.windows.first
        let top: CGFloat = window?.safeAreaInsets.top ?? 0
        let bottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
        let left: CGFloat = window?.safeAreaInsets.left ?? 0
        let right: CGFloat = window?.safeAreaInsets.right ?? 0
        let width: CGFloat = Utility.APP_WIDTH() - left - right
        let height: CGFloat = Utility.APP_HEIGHT() - top - bottom
        var x: CGFloat = 0
        
        if height >= 732 {
            x = ((height - (width - 50) / (16/9) - 334 - 18) / 20)
        } else {
            x = ((height - (width - 50) / (16/9) - 286 - 18) / 20)
        }
        return CGFloat(floorf(Float(x)))
    }
    
//    private func makeCircleWith(size: CGSize, color: UIColor) -> UIImage? {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
//        let context = UIGraphicsGetCurrentContext()
//        context?.setFillColor(color.cgColor)
//        context?.setStrokeColor(UIColor.clear.cgColor)
//        let bounds = CGRect(origin: .zero, size: size)
//        context?.addEllipse(in: bounds)
//        context?.drawPath(using: .fill)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image
//    }
    
    private func makeCircleWith(size: CGSize, color: UIColor, padding: CGFloat = 0.0) -> UIImage? {
        let rendererSize = CGSize(width: size.width, height: size.height + padding * 2)
        let renderer = UIGraphicsImageRenderer(size: rendererSize)
        let image = renderer.image { (context) in
            let circleRect = CGRect(x: 0, y: padding, width: size.width, height: size.height)
            let path = UIBezierPath(ovalIn: circleRect)
            context.cgContext.setFillColor(color.cgColor)
            context.cgContext.addPath(path.cgPath)
            context.cgContext.fillPath()
        }
        return image.resizableImage(withCapInsets: UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0))
    }
}
