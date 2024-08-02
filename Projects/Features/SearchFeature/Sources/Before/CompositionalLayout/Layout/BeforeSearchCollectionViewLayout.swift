import UIKit
import Utility

final class BeforeSearchCollectionViewLayout: UICollectionViewCompositionalLayout {
    init() {
        super.init { sectionIndex, layoutEnvironment in

            guard let layoutKind = BeforeSearchSection(rawValue: sectionIndex) else { return nil }

            return BeforeSearchCollectionViewLayout.configureLayoutSection(layoutKind)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BeforeSearchCollectionViewLayout {
    private static func configureLayoutSection(_ layoutKind: BeforeSearchSection) -> NSCollectionLayoutSection {
        let headerLayout = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))

        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerLayout,
            elementKind: BeforeSearchSectionHeaderView.kind,
            alignment: .top
        )

        let group: NSCollectionLayoutGroup
        let section: NSCollectionLayoutSection

        switch layoutKind {
        case .youtube:

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.87)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: .zero, bottom: 20, trailing: .zero)

        case .recommend:

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalWidth(0.2439)
            )

            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.25)
            )
            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

            group.interItemSpacing = .fixed(8)

            section = NSCollectionLayoutSection(group: group)

            section.boundarySupplementaryItems = [header]
            section.interGroupSpacing = 8.0
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 40, trailing: 20)

        case .popularList:

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )

            let item: NSCollectionLayoutItem = NSCollectionLayoutItem(layoutSize: itemSize)

            #warning("fractional 고민하기")
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(140),
                heightDimension: .absolute(190)
            )

            group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            section = NSCollectionLayoutSection(group: group)

            section.boundarySupplementaryItems = [header]
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
            section.interGroupSpacing = 8
            section.orthogonalScrollingBehavior = .continuous
        }

        return section
    }
}
