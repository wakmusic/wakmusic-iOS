//
//  HomeMainTitleTableViewCell.swift
//  HomeFeature
//
//  Created by Fo co on 2023/03/18.
//  Copyright © 2023 yongbeomkwak. All rights reserved.
//

import ChartDomainInterface
import DesignSystem
import Kingfisher
import RxGesture
import RxSwift
import SnapKit
import UIKit
import Utility

protocol HomeChartCellDelegate: AnyObject {
    func thumbnailDidTap(model: ChartRankingEntity)
    func playButtonDidTap(model: ChartRankingEntity)
}

class HomeChartCell: UITableViewCell {
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var rankImageView: UIImageView!
    @IBOutlet weak var rankChangedLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var songNameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playImageView: UIImageView!

    var delegate: (any HomeChartCellDelegate)?
    private var model: ChartRankingEntity?
    private let disposeBag = DisposeBag()

    override func awakeFromNib() {
        super.awakeFromNib()
        albumImageView.layer.cornerRadius = 4
        albumImageView.contentMode = .scaleAspectFill
        playImageView.image = DesignSystemAsset.Home.playSmall.image
        bind()
    }
}

extension HomeChartCell {
    public func update(model: ChartRankingEntity, index: Int) {
        self.model = model
        albumImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )

        let rankAttributedString = NSMutableAttributedString(
            string: "\(index + 1)",
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 16),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        rankLabel.attributedText = rankAttributedString

        let songNameAttributedString = NSMutableAttributedString(
            string: model.title,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.medium.font(size: 14),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        songNameLabel.attributedText = songNameAttributedString

        let artistAttributedString = NSMutableAttributedString(
            string: model.artist,
            attributes: [
                .font: DesignSystemFontFamily.Pretendard.light.font(size: 12),
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        artistLabel.attributedText = artistAttributedString

        let lastRanking: Int = model.last - (index + 1)
        rankChangedLabel.text = "\(model.last)"

        if model.last == 0 { // NEW
            let rankLabelAttributedString = NSMutableAttributedString(
                string: "NEW",
                attributes: [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 11),
                    .foregroundColor: DesignSystemAsset.PrimaryColor.new.color,
                    .kern: -0.5
                ]
            )
            rankChangedLabel.attributedText = rankLabelAttributedString
            rankChangedLabel.isHidden = false
            rankImageView.isHidden = true

        } else if lastRanking > 99 { // blowup
            rankImageView.image = DesignSystemAsset.Chart.blowup.image
            rankImageView.isHidden = false
            rankChangedLabel.isHidden = true

        } else if lastRanking == 0 { // 변동없음
            rankImageView.image = DesignSystemAsset.Chart.non.image
            rankImageView.isHidden = false
            rankChangedLabel.isHidden = true

        } else if lastRanking > 0 { // UP
            let rankLabelAttributedString = NSMutableAttributedString(
                string: "\(abs(lastRanking))",
                attributes: [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 11),
                    .foregroundColor: DesignSystemAsset.PrimaryColor.increase.color,
                    .kern: -0.5
                ]
            )
            rankChangedLabel.attributedText = rankLabelAttributedString
            rankImageView.image = DesignSystemAsset.Chart.up.image
            rankImageView.isHidden = false
            rankChangedLabel.isHidden = false

        } else if lastRanking < 0 { // DOWN
            let rankLabelAttributedString = NSMutableAttributedString(
                string: "\(abs(lastRanking))",
                attributes: [
                    .font: DesignSystemFontFamily.Pretendard.medium.font(size: 11),
                    .foregroundColor: DesignSystemAsset.PrimaryColor.decrease.color,
                    .kern: -0.5
                ]
            )
            rankChangedLabel.attributedText = rankLabelAttributedString
            rankImageView.image = DesignSystemAsset.Chart.down.image
            rankImageView.isHidden = false
            rankChangedLabel.isHidden = false
        }
    }
}

private extension HomeChartCell {
    func bind() {
        albumImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let model = self?.model else { return }
                self?.delegate?.thumbnailDidTap(model: model)
            }
            .disposed(by: disposeBag)

        playImageView.rx.tapGesture()
            .when(.recognized)
            .bind { [weak self] _ in
                guard let model = self?.model else { return }
                self?.delegate?.playButtonDidTap(model: model)
            }
            .disposed(by: disposeBag)
    }
}
