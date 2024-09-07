import UIKit
import Utility

final class SearchFilterOptionCollectionViewLayout: UICollectionViewCompositionalLayout {
    init() {
        super.init { _, _ in
            return SearchFilterOptionCollectionViewLayout.configureLayout()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchFilterOptionCollectionViewLayout {
    private static func configureLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .fractionalHeight(1.0)
        )

        let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(50),
            heightDimension: .fractionalHeight(1.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)

        section.interGroupSpacing = 4
        section.contentInsets = .init(top: .zero, leading: 20, bottom: .zero, trailing: 30)

        section.orthogonalScrollingBehavior = .continuous

        return section
    }
}
