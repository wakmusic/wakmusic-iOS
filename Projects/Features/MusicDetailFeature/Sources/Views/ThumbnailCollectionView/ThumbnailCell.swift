import Kingfisher
import Then
import UIKit
import Utility

final class ThumbnailCell: UICollectionViewCell {
    private let thumbnailImageView = UIImageView().then {
        $0.backgroundColor = .gray
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
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
    }

    func configure(thumbnailImageURL: String) {
        let rect = CGRect(origin: .zero, size: self.frame.size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIColor.gray.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgImage = image?.cgImage else { return }
        let grayImage = UIImage(cgImage: cgImage)

        thumbnailImageView.kf.setImage(
            with: URL(string: thumbnailImageURL),
            placeholder: grayImage,
            options: [.alsoPrefetchToMemory]
        )
    }
}

private extension ThumbnailCell {
    func addView() {
        self.addSubview(thumbnailImageView)
    }

    func setLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(24)
        }
    }
}
