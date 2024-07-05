import DesignSystem
import Kingfisher
import SnapKit
import Then
import UIKit

final class DefaultThumbnailCell: UICollectionViewCell {
    override var isSelected: Bool {
        willSet(newValue) {}
    }

    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 6
        $0.clipsToBounds = true
        $0.layer.borderColor = UIColor.red.cgColor
        $0.layer.borderWidth = 2
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

    public func configure(_ image: String) {
        imageView.image = UIImage(named: image)
    }
}
