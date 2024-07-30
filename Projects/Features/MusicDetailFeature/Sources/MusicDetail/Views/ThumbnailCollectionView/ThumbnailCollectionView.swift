import UIKit

final class ThumbnailCollectionView: UICollectionView {
    init() {
        super.init(frame: .zero, collectionViewLayout: .init())
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.minimumLineSpacing = 0
        self.isPagingEnabled = true
        self.collectionViewLayout = collectionViewLayout
        self.showsHorizontalScrollIndicator = false
        self.isUserInteractionEnabled = false
        self.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
