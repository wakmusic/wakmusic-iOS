import BaseFeature
import DesignSystem
import LogManager
import RxCocoa
import RxSwift
import SearchDomainInterface
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class ListSearchResultViewController: BaseReactorViewController<ListSearchResultReactor> {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var headerView: SearchOptionHeaderView = SearchOptionHeaderView(false)

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

        let sharedState = reactor.state.share()

        collectionView.rx.willDisplayCell
            .map { $1 }
            .withLatestFrom(
                sharedState.map(\.dataSource),
                resultSelector: { indexPath, datasource -> (IndexPath, Int) in
                    return (indexPath, datasource.count)
                }
            )
            .filter { $0.0.row == $0.1 - 1 } // 마지막 인덱스 접근
            .withLatestFrom(sharedState.map(\.canLoad)) { $1 } // 더 가져올께 있나?
            .filter { $0 }
            .map { _ in ListSearchResultReactor.Action.askLoadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        headerView.rx.tapSortButton
            .bind(with: self) { owner, _ in
                #warning("모달 띄우기")
                print("tap tap")
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: ListSearchResultReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map { $0.sortType }
            .bind(with: self) { owner, sortType in

//                owner.headerView.update(sortType: sortType)
            }
            .disposed(by: disposeBag)

        sharedState.map { ($0.isLoading, $0.dataSource) }
            .bind(with: self) { owner, info in

                let (isLoading, dataSource) = (info.0, info.1)

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()

                    var snapshot = NSDiffableDataSourceSnapshot<ListSearchResultSection, SearchPlaylistEntity>()

                    snapshot.appendSections([.list])

                    snapshot.appendItems(dataSource, toSection: .list)
                    owner.dataSource.apply(snapshot, animatingDifferences: false)

                    let warningView = WMWarningView(
                        frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: APP_HEIGHT()),
                        text: "검색결과가 없습니다."
                    )

                    if dataSource.isEmpty {
                        owner.collectionView.setBackgroundView(warningView, 100)
                    } else {
                        owner.collectionView.restore()
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(headerView, collectionView)
    }

    override func setLayout() {
        super.setLayout()

        headerView.snp.makeConstraints {
            $0.height.equalTo(30)
            $0.top.equalToSuperview().offset(72) // 56 + 16
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom)
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
        let cellRegistration = UICollectionView
            .CellRegistration<ListResultCell, SearchPlaylistEntity> { cell, _, item in
                cell.update(item)
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
