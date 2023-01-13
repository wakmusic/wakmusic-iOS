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

public final class PlayerView: UIView {
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    private lazy var blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .regular)
    }
    
    private lazy var backgroundImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        $0.contentMode = .scaleToFill
        $0.layer.opacity = 0.6
        $0.clipsToBounds = true
    }
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var titleBarView: UIView = UIView()
    
    private lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 16)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "리와인드(RE:WIND)"
    }
    
    private lazy var artistLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.alpha = 0.6
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.2)
        $0.text = "이세계아이돌"
    }
    
    private lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }
    
    private lazy var lyricsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(LyricsTableViewCell.self, forCellReuseIdentifier: LyricsTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 24
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    private lazy var playTimeSlider = CustomSlider().then {
        let circleSize: CGFloat = 8.0
        let circleImage: UIImage? = makeCircleWith(size: CGSize(width: circleSize,
                                                                height: circleSize),
                                                   color: colorFromRGB(0x08DEF7))
        $0.layer.cornerRadius = 1
        $0.setThumbImage(circleImage, for: .normal)
        $0.setThumbImage(circleImage, for: .highlighted)
        $0.maximumTrackTintColor = DesignSystemAsset.GrayColor.gray300.color // 슬라이더 안지나갔을때 컬러 값
        $0.minimumTrackTintColor = DesignSystemAsset.PrimaryColor.point.color
    }
    
    private lazy var playTimeView: UIView = UIView()
    
    private lazy var currentPlayTimeLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.textColor = DesignSystemAsset.PrimaryColor.point.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "0:30"
    }
    
    private lazy var totalPlayTimeLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray400.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "4:34"
    }
    
    private lazy var buttonBarView: UIView = UIView()
    
    private lazy var playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
        $0.tintColor = .systemGray
        $0.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        $0.layer.shadowColor = UIColor.gray.withAlphaComponent(0.25).cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 8)
        $0.layer.shadowRadius = 40
    }
    
    private lazy var prevButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        $0.tintColor = .systemGray
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.nextOn.image, for: .normal)
        $0.tintColor = .systemGray
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    }
    
    private lazy var repeatButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
        $0.tintColor = .systemGray
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    }
    
    private lazy var shuffleButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
        $0.tintColor = .systemGray
        $0.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
    }
    
    private lazy var bottomBarView: UIView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var bottomBarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    
    private lazy var likeButton = VerticalButton().then {
        $0.setImage(DesignSystemAsset.Player.likeOff.image, for: .normal)
        $0.setTitle("1.1만", for: .normal)
        $0.tintColor = .systemGray
        $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel?.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.setTitleColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        $0.alignToVertical()
    }
    
    private lazy var viewsView: UIView = UIView()
    
    private lazy var viewsImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.views.image
    }
    
    private lazy var viewsLabel = UILabel().then {
        $0.text = "1.2만"
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.textColor = DesignSystemAsset.GrayColor.gray400.color
    }
    
    private lazy var addPlayistButton = VerticalButton().then {
        $0.setImage(DesignSystemAsset.Player.playerMusicAdd.image, for: .normal)
        $0.setTitle("노래담기", for: .normal)
        $0.tintColor = .systemGray
        $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel?.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.setTitleColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        $0.alignToVertical()
    }
    
    private lazy var playistButton = VerticalButton().then {
        $0.setImage(DesignSystemAsset.Player.playList.image, for: .normal)
        $0.setTitle("재생목록", for: .normal)
        $0.tintColor = .systemGray
        $0.titleLabel?.font = UIFont(font: DesignSystemFontFamily.Pretendard.medium, size: 12)
        $0.titleLabel?.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 0.98)
        $0.setTitleColor(DesignSystemAsset.GrayColor.gray400.color, for: .normal)
        $0.alignToVertical()
    }
    
    private var firstSpacing: CGFloat = 0
    private var secondSpacing: CGFloat = 0
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        lyricsTableView.delegate = self
        lyricsTableView.dataSource = self
        lyricsTableView.register(LyricsTableViewCell.self, forCellReuseIdentifier: LyricsTableViewCell.identifier)
        lyricsTableView.rowHeight = 24
        lyricsTableView.estimatedRowHeight = 24
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

extension PlayerView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LyricsTableViewCell.identifier, for: indexPath)
        return cell
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

private extension PlayerView {
    private func configureUI() {
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
        
        self.viewsView.addSubview(viewsImageView)
        self.viewsView.addSubview(viewsLabel)
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
        }
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(titleBarView.snp.centerY)
        }
        artistLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleBarView.snp.centerY)
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
        lyricsTableView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.bottom).offset(firstSpacing)
            $0.centerX.equalTo(self.snp.centerX)
            $0.width.equalTo(270)
            $0.height.equalTo(Utility.APP_HEIGHT() >= 812 ? 120 : 72)
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
            $0.top.equalTo(playTimeSlider.snp.bottom).offset(4)
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
            $0.horizontalEdges.equalTo(self.snp.horizontalEdges).inset(UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20))
            $0.height.equalTo(80)
        }
        playButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
        prevButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(playButton.snp.left).offset(-32)
        }
        nextButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(playButton.snp.right).offset(32)
        }
        repeatButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(prevButton.snp.left).offset(-32)
        }
        shuffleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(nextButton.snp.right).offset(32)
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
        viewsImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(4)
            $0.centerX.equalToSuperview()
        }
        viewsLabel.snp.makeConstraints {
            $0.top.equalTo(viewsImageView.snp.bottom)
            $0.centerX.equalToSuperview()
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
        print(x)
        return CGFloat(floorf(Float(x)))
    }
    
    private func makeCircleWith(size: CGSize, color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.setStrokeColor(UIColor.clear.cgColor)
        let bounds = CGRect(origin: .zero, size: size)
        context?.addEllipse(in: bounds)
        context?.drawPath(using: .fill)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
