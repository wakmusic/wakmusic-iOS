import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

#warning("로티 뷰 넣기")
final class YoutubeThumbnailCell: UICollectionViewCell {
    private let thumbnailView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YoutubeThumbnailCell {
    private func addSubviews() {
        contentView.addSubview(thumbnailView)
    }

    private func setLayout() {
        thumbnailView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }
    }

    private func configureUI() {
        #warning("실제 도입 시 frame 변수 제거 고민")

        thumbnailView.layer.cornerRadius = frame.height * 50 / 292

        thumbnailView.image = DesignSystemAsset.Search.testThumbnail.image
    }
}
