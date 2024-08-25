import DesignSystem
import Kingfisher
import Then
import UIKit
import Utility

final class ThumbnailCell: UICollectionViewCell {
    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
    }

    func configure(thumbnailModel: ThumbnailModel) {
        let alternativeSources = [thumbnailModel.alternativeImageURL]
            .compactMap { URL(string: $0) }
            .map { Source.network($0) }

        thumbnailImageView.kf.setImage(
            with: URL(string: thumbnailModel.imageURL),
            placeholder: DesignSystemAsset.Logo.musicDetailPlaceholder.image,
            options: [
                .alsoPrefetchToMemory,
                .alternativeSources(alternativeSources)
            ]
        )
    }
}

private extension ThumbnailCell {
    func addView() {
        self.addSubview(thumbnailImageView)
    }

    func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
            $0.height.equalTo(thumbnailImageView.snp.width).multipliedBy(9.0 / 16.0)
        }
    }
}
