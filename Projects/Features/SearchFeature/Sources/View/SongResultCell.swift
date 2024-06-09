import DesignSystem
import Kingfisher
import LogManager
import SongsDomainInterface
import UIKit
import Utility

final class SongResultCell: UICollectionViewCell {
    private let thumbnailView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    private let artistLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7(weight: .light).lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    private let dateLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .sc7(weight: .score3Light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SongResultCell {
    private func addSubview() {
        self.contentView.addSubviews(thumbnailView, titleLabel, artistLabel, dateLabel)
    }

    private func setLayout() {
        let height = frame.height - 20
        let ratio: CGFloat = 16.0 / 9.0
        let width = ratio * height

        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailView.snp.top).offset(-1)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(8)
        }

        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(thumbnailView.snp.bottom)
        }

        dateLabel.snp.makeConstraints {
            $0.width.equalTo(70)
            $0.centerY.equalTo(thumbnailView.snp.centerY)
            $0.trailing.equalToSuperview()
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
    }

    public func update(_ model: SongEntity) {
        thumbnailView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        titleLabel.text = model.title
        artistLabel.text = model.artist
        dateLabel.text = model.date
    }
}
