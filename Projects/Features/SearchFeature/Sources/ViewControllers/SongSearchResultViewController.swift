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

#warning("오버 스크롤 처리")
final class SongSearchResultViewController: BaseReactorViewController<SongSearchResultReactor>, SongCartViewType {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let searchSortOptionComponent: SearchSortOptionComponent
    
    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var headerView: SearchOptionHeaderView = SearchOptionHeaderView(true)

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        SongSearchResultSection,
        SongEntity
    > = createDataSource()
    
    init(_ reactor:SongSearchResultReactor, _ searchSortOptionComponent:SearchSortOptionComponent) {
        self.searchSortOptionComponent = searchSortOptionComponent
        super.init(reactor: reactor)
       
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)
    }

    override func bind(reactor: SongSearchResultReactor) {
        super.bind(reactor: reactor)
    }

    override func bindAction(reactor: SongSearchResultReactor) {
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
            .map { _ in SongSearchResultReactor.Action.askLoadMore }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        headerView.rx.tapSortButton
            .withLatestFrom(sharedState.map(\.sortType))
            .bind(with: self) { owner, sortType in
                guard let vc = owner.searchSortOptionComponent.makeView(sortType) as? SearchSortOptionViewController else  {
                    return
                }
                
                vc.delegate = owner
                
                owner.showBottomSheet(
                    content: vc,
                    size: .fixed(240+SAFEAREA_BOTTOM_HEIGHT())
                )
            }
            .disposed(by: disposeBag)

        headerView.rx.selectedFilterItem
            .bind(with: self) { owner, type in
                reactor.action.onNext(.changeFilterType(type))
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: SongSearchResultReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.sortType)
            .bind(with: self) { owner, type in
                owner.headerView.updateSortState(type)
            }
            .disposed(by: disposeBag)


        sharedState.map { ($0.isLoading, $0.dataSource) }
            .bind(with: self) { owner, info in

                let (isLoading, dataSource) = (info.0, info.1)

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()

                    var snapshot = NSDiffableDataSourceSnapshot<SongSearchResultSection, SongEntity>()

                    snapshot.appendSections([.song])

                    snapshot.appendItems(dataSource, toSection: .song)

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
            $0.top.equalTo(headerView.snp.bottom).offset(16)
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

extension SongSearchResultViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: SongSearchResultCollectionViewLayout())
    }

    private func createDataSource()
        -> UICollectionViewDiffableDataSource<SongSearchResultSection, SongEntity> {
        let cellRegistration = UICollectionView.CellRegistration<SongResultCell, SongEntity> { cell, _, item in
            cell.update(item)
        }

        let dataSource = UICollectionViewDiffableDataSource<
            SongSearchResultSection,
            SongEntity
        >(collectionView: collectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            item: SongEntity
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

extension SongSearchResultViewController: SearchSortOptionDelegate {
    func updateSortType(_ type: SortType) {
        reactor?.action.onNext(.changeSortType(type))
    }
    
}

extension SongSearchResultViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        #warning("유즈 케이스 연결 시 구현")
        switch type {
        case let .allSelect(flag: flag):
            break
        case .addSong:
            break
        case .addPlayList:
            break
        case .play:
            break
        case .remove:
            break
        }
    }
}
