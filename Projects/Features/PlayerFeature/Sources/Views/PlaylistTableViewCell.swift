//
//  PlaylistTableViewCell.swift
//  PlayerFeature
//
//  Created by YoungK on 2023/02/28.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import UIKit
import DesignSystem
import DomainModule
import SnapKit
import Then
import Lottie
import Kingfisher
import Utility

internal class PlaylistTableViewCell: UITableViewCell {
    static let identifier = "PlaylistTableViewCell"
    
    internal lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailSmall.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }
    
    internal lazy var titleLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.medium, size: 14)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.44)
        $0.text = "곡 제목"
        $0.setLineHeight(lineHeight: 24)
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
    }
    
    internal lazy var artistLabel = UILabel().then {
        $0.font = .init(font: DesignSystemFontFamily.Pretendard.light, size: 12)
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.setLineSpacing(kernValue: -0.5, lineHeightMultiple: 1.26)
        $0.text = "아티스트명"
        $0.setLineHeight(lineHeight: 18)
        $0.textAlignment = .left
        $0.lineBreakMode = .byTruncatingTail
    }
    
    internal lazy var playImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.playLarge.image
        $0.layer.shadowColor = UIColor(red: 0.03, green: 0.06, blue: 0.2, alpha: 0.04).cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 5.33)
        $0.layer.shadowRadius = 5.33
    }
    
    internal lazy var waveStreamAnimationView =
    LottieAnimationView(name: "WaveStream", bundle: DesignSystemResources.bundle).then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
    }
    
    internal var isPlaying: Bool = false {
        didSet {
            updateButtonHidden()
            updateLabelHighlight()
            isPlaying ? waveStreamAnimationView.play() : waveStreamAnimationView.pause()
        }
    }
    
    override var isEditing: Bool {
        didSet {
            replaceAnimation()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }

    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isPlaying = false
    }
    
    private func configureContents() {
        self.backgroundColor = .clear
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.artistLabel)
        self.contentView.addSubview(self.playImageView)
        self.contentView.addSubview(self.waveStreamAnimationView)
        
        let height = 40
        let width = height * 16 / 9
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(thumbnailImageView.snp.right).offset(8)
            $0.right.equalTo(playImageView.snp.left).offset(-16)
            $0.bottom.equalTo(contentView.snp.centerY)
        }
        
        artistLabel.snp.makeConstraints {
            $0.left.equalTo(thumbnailImageView.snp.right).offset(8)
            $0.right.equalTo(playImageView.snp.left).offset(-16)
            $0.top.equalTo(contentView.snp.centerY)
        }
        
        playImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-20)
        }
        
        waveStreamAnimationView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-20)
        }
    }
    
}

extension PlaylistTableViewCell {
    internal func setContent(song: SongEntity) {
        self.thumbnailImageView.kf.setImage(
            with: URL(string: Utility.WMImageAPI.fetchYoutubeThumbnail(id: song.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        
        self.titleLabel.text = song.title
        self.artistLabel.text = song.artist
    }
    
    private func updateButtonHidden() {
        if isEditing {
            playImageView.isHidden = true
            waveStreamAnimationView.isHidden = true
        } else {
            playImageView.isHidden = isPlaying
            waveStreamAnimationView.isHidden = !isPlaying
        }
    }
    
    private func updateLabelHighlight() {
        titleLabel.textColor = isPlaying ? DesignSystemAsset.PrimaryColor.point.color : DesignSystemAsset.GrayColor.gray900.color
        artistLabel.textColor = isPlaying ? DesignSystemAsset.PrimaryColor.point.color : DesignSystemAsset.GrayColor.gray900.color
    }
    
    private func replaceAnimation() {
        if isEditing {
            UIView.animate(withDuration: 0.3) { [weak self] in // 오른쪽으로 사라지는 애니메이션
                guard let self else { return }
                self.playImageView.alpha = 0
                self.playImageView.transform = CGAffineTransform(translationX: 100, y: 0)
                self.playImageView.snp.updateConstraints {
                    $0.right.equalTo(self.contentView.snp.right).offset(24)
                }
                self.waveStreamAnimationView.alpha = 0
                self.waveStreamAnimationView.transform = CGAffineTransform(translationX: 100, y: 0)
                self.waveStreamAnimationView.snp.updateConstraints {
                    $0.right.equalTo(self.contentView.snp.right).offset(24)
                }
                self.layoutIfNeeded()
            } completion: { [weak self] _ in
                guard let self else { return }
                self.playImageView.isHidden = true
                self.waveStreamAnimationView.isHidden = true
            }
        } else {
            self.playImageView.isHidden = isPlaying
            self.waveStreamAnimationView.isHidden = !isPlaying
            UIView.animate(withDuration: 0.3) { [weak self] in // 다시 돌아오는 애니메이션
                guard let self else { return }
                self.playImageView.alpha = 1
                self.playImageView.transform = .identity
                self.playImageView.snp.updateConstraints {
                    $0.right.equalTo(self.contentView.snp.right).offset(-20)
                }
                self.waveStreamAnimationView.alpha = 1
                self.waveStreamAnimationView.transform = .identity
                self.waveStreamAnimationView.snp.updateConstraints {
                    $0.right.equalTo(self.contentView.snp.right).offset(-20)
                }
                self.layoutIfNeeded()
            }
            
        }
    }
    
}
