import DesignSystem
import ImageDomainInterface
import Kingfisher
import SnapKit
import Then
import UIKit

final class DefaultThumbnailCell: UICollectionViewCell {
    override var isSelected: Bool {
        willSet(newValue) {
            imageView.layer.borderWidth = newValue ? 2 : 0
        }
    }

    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.borderColor = DesignSystemAsset.PrimaryColorV2.point.color.cgColor
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DefaultThumbnailCell {
    private func addViews() {
        self.contentView.addSubview(imageView)
    }

    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    public func configure(_ model: DefaultImageEntity) {
        imageView.kf.setImage(with: URL(string: model.url), options: [.transition(.fade(0.2))])
    }
}
