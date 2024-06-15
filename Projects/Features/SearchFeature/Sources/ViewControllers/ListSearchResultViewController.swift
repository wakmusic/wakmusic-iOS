import BaseFeature
import DesignSystem
import LogManager
import RxCocoa
import RxSwift
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility
import SearchDomainInterface


final class ListSearchResultViewController: BaseReactorViewController<ListSearchResultReactor> {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        ListSearchResultSection,
        SearchPlaylistEntity
    > = createDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }

    override func bind(reactor: ListSearchResultReactor) {
        super.bind(reactor: reactor)
        collectionView.delegate = self
    }

    override func bindAction(reactor: ListSearchResultReactor) {
        super.bindAction(reactor: reactor)
    }

    override func bindState(reactor: ListSearchResultReactor) {
        super.bindState(reactor: reactor)
        
        let sharedState = reactor.state.share()
        
        sharedState.map(\.dataSource)
            .distinctUntilChanged()
            .bind(with: self) { owner, dataSource in
                
                var snapshot = NSDiffableDataSourceSnapshot<ListSearchResultSection, SearchPlaylistEntity>()

                snapshot.appendSections([.list])

                snapshot.appendItems(dataSource,toSection: .list)

                owner.dataSource.apply(snapshot, animatingDifferences: false)
                
            }
            .disposed(by: disposeBag)
        
        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoading in

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)
        
        
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(collectionView)
    }

    override func setLayout() {
        super.setLayout()

        collectionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(56)
            $0.bottom.horizontalEdges.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    deinit {
        DEBUG_LOG("❌ \(Self.self) 소멸")
    }
}

extension ListSearchResultViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: ListSearchResultCollectionViewLayout())
    }

    private func createDataSource()
        -> UICollectionViewDiffableDataSource<ListSearchResultSection, SearchPlaylistEntity> {
        let cellRegistration = UICollectionView.CellRegistration<ListResultCell, SearchPlaylistEntity> { cell, _, item in
            cell.update(item)
        }

        // MARK: Header

        let headerRegistration = UICollectionView
            .SupplementaryRegistration<SearchResultHeaderView>(
                elementKind: SearchResultHeaderView
                    .kind
            ) { [weak self] supplementaryView, string, indexPath in

                guard let self else { return }

                supplementaryView.delegate = self
                supplementaryView.update(sortType: .latest)
            }

        let dataSource = UICollectionViewDiffableDataSource<
            ListSearchResultSection,
            SearchPlaylistEntity
        >(collectionView: collectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: SearchPlaylistEntity
        ) -> UICollectionViewCell? in

            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: item
            )
        }

        dataSource.supplementaryViewProvider = { collectionView, _, index in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        return dataSource
    }


    public func scrollToTop() {}
}

extension ListSearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #warning("플레이리스트 상세로 이동")
        guard let model = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        LogManager.printDebug(model)
    }
}

extension ListSearchResultViewController: SearchResultHeaderViewDelegate {
    func tapFilter() {
        LogManager.printDebug("filter")
    }

    func tapSort() {
        LogManager.printDebug("sort")
    }
}
