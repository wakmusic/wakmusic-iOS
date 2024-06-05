import UIKit
import Utility

final class SearchResultCollecctionViewLayout: UICollectionViewCompositionalLayout {
    init() {
        super.init { _, _ in

            return SearchResultCollecctionViewLayout.configureLayout()
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchResultCollecctionViewLayout {
    private static func configureLayout() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
        )
        var item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.25)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        group.interItemSpacing = .fixed(8.0)
        group.contentInsets = .init(top: 8.0, leading: 20, bottom: 8.0, trailing: 20)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: .zero, bottom: .zero, trailing: .zero)

        return section
    }
}
