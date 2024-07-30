import UIKit

final class CreditCollectionViewLayout: UICollectionViewFlowLayout {
    private enum Metric {
        static let headerViewWidth: CGFloat = 66
        static let headerViewHeight: CGFloat = 28
        static let sectionSpacing: CGFloat = 20
    }

    override init() {
        super.init()
        self.sectionInset = .init(
            top: 0,
            left: Metric.headerViewWidth,
            bottom: 0,
            right: 0
        )
        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.headerReferenceSize = .init(width: Metric.headerViewWidth, height: Metric.sectionSpacing)
        self.minimumLineSpacing = 8
        self.minimumInteritemSpacing = 6
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0

        for layoutAttribute in attributes ?? [] {
            if let kind = layoutAttribute.representedElementKind {
                switch kind {
                case UICollectionView.elementKindSectionHeader:
                    var frame = layoutAttribute.frame

                    frame.origin.y += frame.size.height

                    frame.size.width = sectionInset.left
                    frame.size.height = Metric.headerViewHeight

                    layoutAttribute.frame = frame

                default:
                    break
                }
            } else {
                if layoutAttribute.frame.origin.y >= maxY {
                    leftMargin = sectionInset.left
                }

                layoutAttribute.frame.origin.x = leftMargin

                leftMargin += layoutAttribute.frame.width + 8
                maxY = max(layoutAttribute.frame.maxY, maxY)
            }
        }
        return attributes
    }
}
