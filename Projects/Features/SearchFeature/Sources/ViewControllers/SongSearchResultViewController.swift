import BaseFeature
import BaseFeatureInterface
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

final class SongSearchResultViewController: BaseReactorViewController<SongSearchResultReactor>, SongCartViewType {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let containSongsFactory: any ContainSongsFactory

    private let searchSortOptionComponent: SearchSortOptionComponent

    private let searchGlobalScrollState: any SearchGlobalScrollPortocol

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
    }

    private lazy var headerView: SearchOptionHeaderView = SearchOptionHeaderView(true)

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        SongSearchResultSection,
        SongEntity
    > = createDataSource()

    init(
        _ reactor: SongSearchResultReactor,
        searchSortOptionComponent: SearchSortOptionComponent,
        containSongsFactory: any ContainSongsFactory,
        searchGlobalScrollState: any SearchGlobalScrollPortocol
    ) {
        self.searchSortOptionComponent = searchSortOptionComponent
        self.containSongsFactory = containSongsFactory
        self.searchGlobalScrollState = searchGlobalScrollState
        super.init(reactor: reactor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reactor?.action.onNext(.deselectAll)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        searchGlobalScrollState.expand()
    }
    

    override func bind(reactor: SongSearchResultReactor) {
        super.bind(reactor: reactor)
        collectionView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        searchGlobalScrollState.songResultScrollToTopObservable
            .observe(on: MainScheduler.asyncInstance)
            .bind(with: self) { owner, _ in
                owner.collectionView.setContentOffset(.zero, animated: true)

            }
            .disposed(by: disposeBag)
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

        headerView.rx.didTapSortButton
            .withLatestFrom(sharedState.map(\.sortType)) { $1 }
            .bind(with: self) { owner, sortType in
                guard let vc = owner.searchSortOptionComponent.makeView(sortType) as? SearchSortOptionViewController
                else {
                    return
                }

                vc.delegate = owner

                owner.showBottomSheet(
                    content: vc,
                    size: .fixed(240 + SAFEAREA_BOTTOM_HEIGHT())
                )
            }
            .disposed(by: disposeBag)

        headerView.rx.selectedFilterItem
            .distinctUntilChanged()
            .bind(with: self) { owner, type in
                reactor.action.onNext(.changeFilterType(type))
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: SongSearchResultReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .bind(with: self) { owner, message in
                owner.showToast(text: message, font: .setFont(.t6(weight: .light)))
            }
            .disposed(by: disposeBag)

        sharedState.map(\.sortType)
            .distinctUntilChanged()
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

                    snapshot.appendItems(dataSource)

                    owner.dataSource.apply(snapshot, animatingDifferences: false)

                    let warningView = WMWarningView(text: "검색결과가 없습니다.")

                    if dataSource.isEmpty {
                        owner.collectionView.setBackgroundView(warningView, 100)
                    } else {
                        owner.collectionView.restore()
                    }
                }
            }
            .disposed(by: disposeBag)

        sharedState.map(\.selectedCount)
            .distinctUntilChanged()
            .withLatestFrom(sharedState.map(\.dataSource)) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (count, limit) = (info.0, info.1.count)

                if count == .zero {
                    owner.hideSongCart()
                } else {
                    owner.showSongCart(
                        in: owner.view,
                        type: .searchSong,
                        selectedSongCount: count,
                        totalSongCount: limit,
                        useBottomSpace: false
                    )
                    owner.songCartView.delegate = owner
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
            $0.leading.trailing.equalToSuperview()
        }

        collectionView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(8)
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

    public func scrollToTop() {
        collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}

extension SongSearchResultViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reactor?.action.onNext(.itemDidTap(indexPath.row))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard collectionView.isVerticallyScrollable else { return }
        searchGlobalScrollState.scrollTo(
            source: (
                scrollView.contentOffset.y,
                scrollView.contentSize.height - scrollView.frame.size.height
            )
        )
    }
}

extension SongSearchResultViewController: SearchSortOptionDelegate {
    func updateSortType(_ type: SortType) {
        if reactor?.currentState.sortType != type {
            reactor?.action.onNext(.changeSortType(type))
        }
    }
}

extension SongSearchResultViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        guard let reactor = reactor else {
            return
        }

        let currentState = reactor.currentState

        switch type {
        case let .allSelect(flag: flag):
            break
        case .addSong:
            let vc = containSongsFactory.makeView(songs: currentState.dataSource.filter { $0.isSelected }.map { $0.id })
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)

        case .addPlayList:
            #warning("재생목록 관련 구현체 구현 시 추가")
            break
        case .play:
            #warning("재생 구현")
            break
        case .remove:
            break
        }

        reactor.action.onNext(.deselectAll)
    }
}
