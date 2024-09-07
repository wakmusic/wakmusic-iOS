import BaseFeature
import BaseFeatureInterface
import CreditSongListFeatureInterface
import DesignSystem
import LogManager
import RxSwift
import SignInFeatureInterface
import Then
import UIKit
import Utility

final class CreditSongListTabItemViewController:
    BaseReactorViewController<CreditSongListTabItemReactor>,
    SongCartViewType {
    var songCartView: SongCartView!
    var bottomSheetView: BottomSheetView!

    private typealias SectionType = Int
    private typealias ItemType = CreditSongModel

    private lazy var dataSource = makeCreditSongListDataSource()

    private lazy var creditSongListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCreditSongListCollectionViewLayout()
    ).then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray100.color
        $0.delegate = self
        $0.contentInset = .init(top: 16, left: 0, bottom: .songCartHeight, right: 0)
        $0.scrollIndicatorInsets = .init(top: 0, left: 0, bottom: .songCartHeight, right: 0)
    }

    private let songCartContainerView = UIView().then {
        $0.backgroundColor = .clear
    }

    private lazy var creditSongCellRegistration = UICollectionView.CellRegistration<
        CreditSongCollectionViewCell,
        CreditSongModel
    > { [reactor] cell, _, model in
        let isSelected = reactor?.currentState.selectedSongs.contains(model.id) ?? false
        cell.update(model, isSelected: isSelected)

        cell.setThumbnailTapHandler { [reactor, model] in
            reactor?.action.onNext(.songThumbnailDidTap(model: model))
        }
    }

    private lazy var creditSongHeaderRegistration = UICollectionView
        .SupplementaryRegistration<CreditSongCollectionHeaderView>(
            elementKind: UICollectionView.elementKindSectionHeader
        ) { [reactor] headerView, _, _ in
            headerView.setPlayButtonHandler {
                let log = CommonAnalyticsLog.clickPlayButton(location: .creditSongList, type: .random)
                LogManager.analytics(log)

                reactor?.action.onNext(.randomPlayButtonDidTap)
            }
        }

    private let containSongsFactory: any ContainSongsFactory
    private let textPopupFactory: any TextPopupFactory
    private let signInFactory: any SignInFactory

    init(
        reactor: Reactor,
        containSongsFactory: any ContainSongsFactory,
        textPopupFactory: any TextPopupFactory,
        signInFactory: any SignInFactory
    ) {
        self.containSongsFactory = containSongsFactory
        self.textPopupFactory = textPopupFactory
        self.signInFactory = signInFactory
        super.init(reactor: reactor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reactor?.action.onNext(.viewDidLoad)
    }

    override func addView() {
        view.addSubviews(creditSongListCollectionView, songCartContainerView)
    }

    override func setLayout() {
        creditSongListCollectionView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.top.equalToSuperview().offset(CGFloat.offsetForTabbarHeight)
        }

        songCartContainerView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalToSuperview()
            $0.height.equalTo(CGFloat.songCartHeight + SAFEAREA_BOTTOM_HEIGHT())
        }
    }

    override func bindAction(reactor: CreditSongListTabItemReactor) {
        creditSongListCollectionView.rx.itemSelected
            .compactMap { [reactor] in
                reactor.currentState.songs[safe: $0.row]
            }
            .map { Reactor.Action.songDidTap(id: $0.id) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        creditSongListCollectionView.rx.prefetchItems
            .compactMap(\.last)
            .map(\.row)
            .filter { lastPrefetchedIndex in
                reactor.currentState.songs.count - 1 == lastPrefetchedIndex
            }
            .filter { _ in reactor.currentState.isLoading == false }
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .map { _ in Reactor.Action.reachedBottom }
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

        sharedState.map(\.selectedSongs)
            .distinctUntilChanged()
            .bind(with: self) { owner, selectedSongs in
                if selectedSongs.count == .zero {
                    owner.hideSongCart()
                } else {
                    owner.showSongCart(
                        in: owner.songCartContainerView,
                        type: .creditSong,
                        selectedSongCount: selectedSongs.count,
                        totalSongCount: owner.reactor?.currentState.songs.count ?? selectedSongs.count,
                        useBottomSpace: true
                    )
                    owner.songCartView.delegate = owner
                }
                var snapshot = owner.dataSource.snapshot()
                snapshot.reconfigureItems(snapshot.itemIdentifiers)
                owner.dataSource.apply(snapshot)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$navigateType)
            .compactMap { $0 }
            .bind(with: self) { owner, navigate in
                switch navigate {
                case let .playYoutube(ids, playPlatform):
                    owner.playYoutube(ids: ids, playPlatform: playPlatform)
                case let .containSongs(ids):
                    owner.presentContainSongs(ids: ids)
                case let .textPopup(text, completion):
                    owner.presentTextPopup(text: text, completion: completion)
                case .signIn:
                    owner.presentSignIn()
                case let .dismiss(completion):
                    owner.dismiss(completion: completion)
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$isLoading)
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.indicator.startAnimating()
                } else {
                    owner.indicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$toastMessage)
            .compactMap { $0 }
            .bind(with: self) { owner, message in
                owner.showToast(text: message, options: [.songCart])
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegate

extension CreditSongListTabItemViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        CreditSongListScopedState.shared.didScroll(scrollView: scrollView)
    }
}

// MARK: - SongCartViewDelegate

extension CreditSongListTabItemViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        guard let reactor = reactor else { return }

        let currentState = reactor.currentState

        let songs = currentState.songs
            .filter { currentState.selectedSongs.contains($0.id) }

        switch type {
        case let .allSelect(isAll):
            if isAll {
                reactor.action.onNext(.allSelectButtonDidTap)
            } else {
                reactor.action.onNext(.allDeselectButtonDidTap)
            }
        case .addSong:
            reactor.action.onNext(.addSongButtonDidTap)

        case .addPlayList:
            reactor.action.onNext(.addPlaylistButtonDidTap)

        case .play:
            reactor.action.onNext(.playButtonDidTap)

        default:
            break
        }
    }
}

// MARK: - Private Method

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
            top: .playButtonTopMargin,
            leading: .playButtonHorizontalMargin,
            bottom: .playButtonBottomMargin,
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

    private func playYoutube(ids: [String], playPlatform: WakmusicYoutubePlayer.PlayPlatform) {
        let worker = reactor?.workerName ?? "작업자"
        let title = "\(worker)님과 함께하는 랜뮤"
        WakmusicYoutubePlayer(ids: ids, title: title, playPlatform: playPlatform).play()
    }

    private func presentContainSongs(ids: [String]) {
        let viewController = containSongsFactory.makeView(songs: ids)
        viewController.modalPresentationStyle = .overFullScreen
        UIApplication.topVisibleViewController()?.present(viewController, animated: true)
    }

    private func presentTextPopup(text: String, completion: @escaping () -> Void) {
        let viewController = textPopupFactory.makeView(
            text: text,
            cancelButtonIsHidden: false,
            confirmButtonText: "확인",
            cancelButtonText: "취소",
            completion: completion,
            cancelCompletion: nil
        )

        self.showBottomSheet(content: viewController)
    }

    private func presentSignIn() {
        let viewController = signInFactory.makeView()
        viewController.modalPresentationStyle = .overFullScreen
        UIApplication.topVisibleViewController()?.present(viewController, animated: true)
    }

    private func dismiss(completion: @escaping () -> Void) {
        UIApplication.keyRootViewController?.dismiss(animated: true, completion: completion)
    }
}

private extension CGFloat {
    static let offsetForTabbarHeight: CGFloat = 36
    static let playButtonHeight: CGFloat = 52 + 10
    static let playButtonHorizontalMargin: CGFloat = 20
    static let playButtonTopMargin: CGFloat = 0
    static let playButtonBottomMargin: CGFloat = 10
    static let songCartHeight: CGFloat = 56
}
