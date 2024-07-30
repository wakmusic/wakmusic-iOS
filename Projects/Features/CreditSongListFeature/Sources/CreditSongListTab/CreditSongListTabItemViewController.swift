import BaseFeature
import CreditSongListFeatureInterface
import DesignSystem
import UIKit
import Utility

final class CreditSongListTabItemViewController: BaseReactorViewController<CreditSongListTabItemReactor> {
    private typealias SectionType = Int
    private typealias ItemType = CreditSongModel

    private lazy var dataSource = makeCreditSongListDataSource()

    private lazy var creditSongListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCreditSongListCollectionViewLayout()
    ).then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        $0.delegate = self
        $0.contentInset = .init(top: 12, left: 0, bottom: 0, right: 0)
    }

    private lazy var creditSongCellRegistration = UICollectionView.CellRegistration<
        CreditSongCollectionViewCell,
        CreditSongModel
    > { cell, _, model in
        cell.update(model, isSelected: false)
    }

    private lazy var creditSongHeaderRegistration = UICollectionView
        .SupplementaryRegistration<CreditSongCollectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { headerView, elementKind, indexPath in
        }

    override func addView() {
        view.addSubviews(creditSongListCollectionView)
    }

    override func setLayout() {
        creditSongListCollectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(CGFloat.offsetForTabbarHeight)
        }
    }

    override func bindAction(reactor: CreditSongListTabItemReactor) {
        self.rx.methodInvoked(#selector(viewDidLoad))
            .map { _ in Reactor.Action.viewDidLoad }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: CreditSongListTabItemReactor) {
        let sharedState = reactor.state.share()

        sharedState.map(\.songs)
            .distinctUntilChanged()
            .bind(with: self) { owner, songs in
                var snapshot = NSDiffableDataSourceSnapshot<SectionType, ItemType>()
                snapshot.appendSections([0])
                snapshot.appendItems(songs, toSection: 0)
                owner.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
    }
}

extension CreditSongListTabItemViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        CreditSongListScopedState.shared.didScroll(scrollView: scrollView)
    }
}

extension CreditSongListTabItemViewController {
    private func makeCreditSongListCollectionViewLayout() -> UICollectionViewLayout {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        config.showsSeparators = false
        config.headerMode = .supplementary
        config.headerTopPadding = 0
        config.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(CGFloat.playButtonHeight)
        )
        let headerSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        headerSupplementary.pinToVisibleBounds = true
        headerSupplementary.contentInsets = .init(
            top: .playButtonVerticalMargin,
            leading: .playButtonHorizontalMargin,
            bottom: .playButtonVerticalMargin,
            trailing: .playButtonHorizontalMargin
        )

        return UICollectionViewCompositionalLayout { _, layoutEnvironment in
            let section = NSCollectionLayoutSection.list(using: config, layoutEnvironment: layoutEnvironment)
            section.boundarySupplementaryItems = [headerSupplementary]
            return section
        }
    }

    private func makeCreditSongListDataSource() -> UICollectionViewDiffableDataSource<SectionType, ItemType> {
        let dataSource: UICollectionViewDiffableDataSource = UICollectionViewDiffableDataSource<
            SectionType,
            ItemType
        >.init(
            collectionView: creditSongListCollectionView
        ) { [creditSongCellRegistration] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(
                using: creditSongCellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
            return cell
        }
        dataSource.supplementaryViewProvider = { [creditSongHeaderRegistration] collectionView, kind, indexPath in
            let headerView = collectionView.dequeueConfiguredReusableSupplementary(
                using: creditSongHeaderRegistration,
                for: indexPath
            )
            return headerView
        }

        return dataSource
    }
}

private extension CGFloat {
    static let offsetForTabbarHeight: CGFloat = 36
    static let playButtonHeight: CGFloat = 52
    static let playButtonHorizontalMargin: CGFloat = 20
    static let playButtonVerticalMargin: CGFloat = 0
}
