import UIKit
import Utility

final class RecommendCollectionViewLayout: UICollectionViewCompositionalLayout {
    init() {
        super.init { _, _ in

            return RecommendCollectionViewLayout.configureLayout()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendCollectionViewLayout {
    private static func configureLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalWidth(0.2439)
        )

        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: .zero, trailing: 20)

        return section
    }
}
