import DesignSystem
import SnapKit
import Then
import UIKit
import Utility

class YoutubeThumbnailCell: UICollectionViewCell {
    var thumbnailView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension YoutubeThumbnailCell {
    func configureUI() {
        contentView.addSubview(thumbnailView)

        thumbnailView.snp.makeConstraints {
            $0.verticalEdges.horizontalEdges.equalToSuperview()
        }

        thumbnailView.layer.cornerRadius = frame.height * 50 / 292

        thumbnailView.image = DesignSystemAsset.Search.testThumbnail.image
    }
}
