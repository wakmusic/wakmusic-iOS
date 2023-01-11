//
//  NewPlayerViewController.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/01/09.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import SwiftUI
import Utility
import DesignSystem
import SnapKit
import Then

public class NewPlayerViewController: UIViewController {
    
    private lazy var backgroundView = UIView().then {
        $0.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
    }
    
    private lazy var blurEffectView = UIVisualEffectView().then {
        $0.effect = UIBlurEffect(style: .regular)
    }
    
    private lazy var backgroundImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailLarge.image
        $0.layer.opacity = 0.6
    }
    
    private lazy var contentView: UIView = UIView()
    
    private lazy var titleBarView: UIView = UIView()
    
    private lazy var closeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Navigation.close.image, for: .normal)
        $0.tintColor = .systemGray
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
        $0.image = UIImage(named: DesignSystemAsset.Player.dummyThumbnailLarge.name)
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
    }
    
    private lazy var lyricsTableView = UITableView(frame: .zero, style: .plain).then {
        $0.register(LyricsTableViewCell.self, forCellReuseIdentifier: LyricsTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 24
    }
    
    private lazy var playTimeSlider = CustomSlider().then {
        let circleSize: CGFloat = 8.0
        let circleImage: UIImage? = makeCircleWith(size: CGSize(width: circleSize,
                                                                height: circleSize),
                                                   color: colorFromRGB(0x08DEF7))
        $0.layer.cornerRadius = 1
        $0.setThumbImage(circleImage, for: .normal)
        $0.setThumbImage(circleImage, for: .highlighted)
        $0.maximumTrackTintColor = colorFromRGB(0xD0D5DD) // 슬라이더 안지나갔을때 컬러 값
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
    }
    
    private lazy var prevButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var nextButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.prevOn.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var repeatButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.repeatOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var shuffleButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.shuffleOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var bottomBarStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    private lazy var likeButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.likeOff.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var viewsImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.views.image
    }
    
    private lazy var addPlayistButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.playerMusicAdd.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private lazy var playistButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.playList.image, for: .normal)
        $0.tintColor = .systemGray
    }
    
    private var firstSpacing: CGFloat = 0
    private var secondSpacing: CGFloat = 0
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindViewModel()
        bindUI()
    }
}

public extension NewPlayerViewController {
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

private extension NewPlayerViewController {
    private func bindViewModel() {
    }
    
    private func bindUI() {
    }
    
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
        self.view.addSubview(backgroundView)
        self.view.addSubview(contentView)
        
        self.backgroundView.addSubview(backgroundImageView)
        self.backgroundImageView.addSubview(blurEffectView)
        
        self.contentView.addSubview(titleBarView)
        self.contentView.addSubview(thumbnailImageView)
        self.contentView.addSubview(lyricsTableView)
        self.contentView.addSubview(playTimeSlider)
        self.contentView.addSubview(playTimeView)
        self.contentView.addSubview(buttonBarView)
        self.contentView.addSubview(bottomBarStackView)
        
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
        
        self.bottomBarStackView.addArrangedSubview(likeButton)
        self.bottomBarStackView.addArrangedSubview(viewsImageView)
        self.bottomBarStackView.addArrangedSubview(addPlayistButton)
        self.bottomBarStackView.addArrangedSubview(playistButton)
    }
    
    private func configureBackground() {
        
    }
    private func configureContent() {
        
    }
    private func configureTitleBar() {
        
    }
    private func configureThumbnail() {
        
    }
    private func configureLyrics() {
        
    }
    private func configurePlayTimeSlider() {
        
    }
    private func configurePlayTime() {
        
    }
    private func configureButtonBar() {
        
    }
    private func configureBottomBar() {
        
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
            x = ((height - (width - 50)/1.8 - 334 - 18) / 20)
        } else {
            x = ((height - (width - 50)/1.8 - 286 - 18) / 20)
        }
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

struct NewPlayerViewController_Previews: PreviewProvider {
    static var previews: some View {
        NewPlayerViewController().toPreview()
    }
}

class LyricsTableViewCell: UITableViewCell {
    static let identifier = "LyricsTableViewCell"
    
    private lazy var lyricsLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray500.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        $0.text = "기억나 우리 처음 만난 날"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(self.lyricsLabel)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
}
