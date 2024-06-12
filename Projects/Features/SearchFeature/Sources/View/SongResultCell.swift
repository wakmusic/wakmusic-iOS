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

    private let titleLabel: UILabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .setFont(.t6(weight: .medium))
        $0.textColor = DesignSystemAsset.NewGrayColor.gray900.color
    }

    private let artistLabel: UILabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = .setFont(.t7(weight: .light))
        $0.textColor = DesignSystemAsset.NewGrayColor.gray900.color
    }

    private let dateLabel: UILabel = UILabel().then {
        $0.numberOfLines = 1
        $0.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
        $0.textColor = DesignSystemAsset.NewGrayColor.gray900.color
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
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
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
