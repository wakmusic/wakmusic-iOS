import SnapKit
import Then
import UIKit

final class CreditSongCollectionHeaderView: UICollectionReusableView {
    private let randomPlayButton = RandomPlayButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        layer.zPosition = 1
    }

    private func setupViews() {
        addSubview(randomPlayButton)
        randomPlayButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
