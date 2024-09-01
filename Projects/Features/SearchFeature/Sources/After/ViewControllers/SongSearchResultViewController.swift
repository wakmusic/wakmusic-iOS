import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import RxCocoa
import RxSwift
import SearchDomainInterface
import SignInFeatureInterface
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class SongSearchResultViewController: BaseReactorViewController<SongSearchResultReactor>, SongCartViewType {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let songDetailPresenter: any SongDetailPresentable
    private let containSongsFactory: any ContainSongsFactory
    private let signInFactory: any SignInFactory
    private let textPopupFactory: any TextPopupFactory
    private let searchSortOptionComponent: SearchSortOptionComponent
    private let searchGlobalScrollState: any SearchGlobalScrollProtocol

    private lazy var collectionView: UICollectionView = createCollectionView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        $0.scrollIndicatorInsets = .init(top: .zero, left: .zero, bottom: 56.0, right: .zero)
        $0.isHidden = true
    }

    private lazy var headerView: SearchOptionHeaderView = SearchOptionHeaderView(true)

    private let songCartContainerView: UIView = UIView().then {
        $0.alpha = .zero
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<
        SongSearchResultSection,
        SongEntity
    > = createDataSource()

    init(
        _ reactor: SongSearchResultReactor,
        searchSortOptionComponent: SearchSortOptionComponent,
        songDetailPresenter: any SongDetailPresentable,
        containSongsFactory: any ContainSongsFactory,
        signInFactory: any SignInFactory,
        textPopupFactory: any TextPopupFactory,
        searchGlobalScrollState: any SearchGlobalScrollProtocol
    ) {
        self.searchSortOptionComponent = searchSortOptionComponent
        self.containSongsFactory = containSongsFactory
        self.songDetailPresenter = songDetailPresenter
        self.signInFactory = signInFactory
        self.textPopupFactory = textPopupFactory
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
            .filter { $0.0.row == $0.1 - 1 } // 마지막 인덱스 접근 확인
            .map { _ in () }
            .withLatestFrom(sharedState.map(\.isLoading)) // 로딩 중 확인
            .filter { !$0 }
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
            .bind(with: self) { _, type in
                LogManager.analytics(SearchAnalyticsLog.selectSearchFilter(option: type.rawValue))
                reactor.action.onNext(.changeFilterType(type))
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: SongSearchResultReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .withLatestFrom(sharedState.map(\.selectedCount)) { ($0, $1) }
            .bind(with: self) { owner, info in

                let(message, count) = (info.0, info.1)

                owner.showToast(text: message, options: count == .zero ? [.tabBar] : [.tabBar, .songCart])
            }
            .disposed(by: disposeBag)

        sharedState.map(\.sortType)
            .distinctUntilChanged()
            .bind(with: self) { owner, type in
                owner.headerView.updateSortState(type)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.isLoading)
            .bind(with: self) { owner, isLoading in

                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.collectionView.isHidden = false
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        sharedState.map { $0.dataSource }
            .distinctUntilChanged()
            .bind(with: self) { owner, dataSource in
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
            .disposed(by: disposeBag)

        sharedState.map(\.selectedCount)
            .distinctUntilChanged()
            .withLatestFrom(sharedState.map(\.dataSource)) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (count, limit) = (info.0, info.1.count)
                if count == .zero {
                    UIView.animate(withDuration: 0.5) {
                        owner.songCartContainerView.alpha = .zero
                    }
                    owner.hideSongCart()
                } else {
                    owner.songCartContainerView.alpha = 1.0
                    owner.showSongCart(
                        in: owner.songCartContainerView,
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
        self.view.addSubviews(headerView, collectionView, songCartContainerView)
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

        songCartContainerView.snp.makeConstraints {
            $0.height.equalTo(56)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    deinit {
        LogManager.printDebug("❌ \(Self.self) 소멸")
    }
}

extension SongSearchResultViewController {
    private func createCollectionView() -> UICollectionView {
        return UICollectionView(frame: .zero, collectionViewLayout: SongSearchResultCollectionViewLayout())
    }

    private func createDataSource()
        -> UICollectionViewDiffableDataSource<SongSearchResultSection, SongEntity> {
        let cellRegistration = UICollectionView
            .CellRegistration<SongResultCell, SongEntity> { [weak self] cell, _, item in

                guard let self else { return }

                cell.delegate = self
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
        LogManager.analytics(SearchAnalyticsLog.selectSearchSort(option: type.rawValue, category: "song"))
        if reactor?.currentState.sortType != type {
            reactor?.action.onNext(.changeSortType(type))
        }
    }
}

extension SongSearchResultViewController: SongResultCellDelegate {
    func thumbnailDidTap(key: String) {
        guard let tappedSong = reactor?.currentState.dataSource
            .first(where: { $0.id == key })
        else { return }
        PlayState.shared.append(item: .init(id: tappedSong.id, title: tappedSong.title, artist: tappedSong.artist))
        let playlistIDs = PlayState.shared.currentPlaylist
            .map(\.id)
        songDetailPresenter.present(ids: playlistIDs, selectedID: key)
    }
}

extension SongSearchResultViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        guard let reactor = reactor else {
            return
        }

        let currentState = reactor.currentState
        let songs = currentState.dataSource.filter { $0.isSelected }
        let limit = 50

        switch type {
        case .allSelect(_):
            break
        case .addSong:
            let log = CommonAnalyticsLog.clickAddMusicsButton(location: .search)
            LogManager.analytics(log)

            guard songs.count <= limit else {
                showToast(
                    text: LocalizationStrings.overFlowContainWarning(songs.count - limit),
                    options: [.tabBar, .songCart]
                )
                return
            }

            if PreferenceManager.userInfo == nil {
                let vc = self.textPopupFactory.makeView(
                    text: LocalizationStrings.needLoginWarning,
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let log = CommonAnalyticsLog.clickLoginButton(entry: .addMusics)
                        LogManager.analytics(log)

                        let loginVC = self.signInFactory.makeView()
                        loginVC.modalPresentationStyle = .fullScreen
                        self.present(loginVC, animated: true)
                    },
                    cancelCompletion: {}
                )
                self.showBottomSheet(content: vc)
                return
            }

            let vc = containSongsFactory.makeView(songs: songs.map(\.id))
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            reactor.action.onNext(.deselectAll)

        case .addPlayList:

            guard songs.count <= limit else {
                showToast(
                    text: LocalizationStrings.overFlowAddPlaylistWarning(songs.count - limit),
                    options: [.tabBar, .songCart]
                )
                return
            }
            showToast(
                text: Localization.LocalizationStrings.addList,
                options: [.tabBar]
            )
            PlayState.shared.append(contentsOf: songs.map { PlaylistItem(item: $0) })
            reactor.action.onNext(.deselectAll)

        case .play:
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .search, type: .multiple)
            )
            guard songs.count <= limit else {
                showToast(
                    text: LocalizationStrings.overFlowPlayWarning(songs.count - limit),
                    options: [.tabBar, .songCart]
                )
                return
            }

            PlayState.shared.append(contentsOf: songs.map { PlaylistItem(item: $0) })
            if songs.allSatisfy({ $0.title.isContainShortsTagTitle }) {
                WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직", playPlatform: .youtube).play()
            } else {
                WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직").play()
            }
            reactor.action.onNext(.deselectAll)

        case .remove:
            break
        }
    }
}
