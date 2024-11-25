//
//  HomeNewSongCell.swift
//  HomeFeature
//
//  Created by KTH on 2023/03/19.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import DesignSystem
import Kingfisher
import RxGesture
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

@MainActor
protocol HomeNewSongCellDelegate: AnyObject {
    func thumbnailDidTap(model: NewSongsEntity)
    func playButtonDidTap(model: NewSongsEntity)
}

final class HomeNewSongCell: UICollectionViewCell {
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!

    private var model: NewSongsEntity?
    weak var delegate: (any HomeNewSongCellDelegate)?
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()

        Task { @MainActor in
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear

            albumImageView.layer.cornerRadius = 8
            albumImageView.clipsToBounds = true
            albumImageView.contentMode = .scaleAspectFill
            playImageView.image = DesignSystemAsset.Home.playSmall.image
            bind()
        }
    }
}

extension HomeNewSongCell {
    func update(model: NewSongsEntity) {
        self.model = model
        let titleAttributedString = NSMutableAttributedString(
            string: model.title,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        titleStringLabel.attributedText = titleAttributedString

        let artistAttributedString = NSMutableAttributedString(
            string: model.artist,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        artistLabel.attributedText = artistAttributedString

        albumImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderMedium.image,
            options: [.transition(.fade(0.2))]
        )
    }
}

private extension HomeNewSongCell {
    func bind() {
        albumImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let newSongEntity = self?.model else { return }
                self?.delegate?.thumbnailDidTap(model: newSongEntity)
            }
            .disposed(by: disposeBag)

        playImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let newSongEntity = self?.model else { return }
                self?.delegate?.playButtonDidTap(model: newSongEntity)
            }
            .disposed(by: disposeBag)
    }
}
