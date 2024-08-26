import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import NVActivityIndicatorView
import PlaylistFeatureInterface
import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import SignInFeatureInterface
import SongsDomainInterface
import UIKit
import UserDomainInterface
import Utility

typealias LikeSectionModel = SectionModel<Int, FavoriteSongEntity>

final class LikeStorageViewController: BaseReactorViewController<LikeStorageReactor>, SongCartViewType {
    let likeStorageView = LikeStorageView()

    var containSongsFactory: ContainSongsFactory!
    var textPopupFactory: TextPopupFactory!
    var signInFactory: SignInFactory!
    var songDetailPresenter: SongDetailPresentable!

    var songCartView: SongCartView!
    var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared

    override func loadView() {
        super.loadView()
        self.view = likeStorageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .storageLike))
    }

    static func viewController(
        reactor: Reactor,
        containSongsFactory: ContainSongsFactory,
        textPopupFactory: TextPopupFactory,
        signInFactory: SignInFactory,
        songDetailPresenter: SongDetailPresentable
    ) -> LikeStorageViewController {
        let viewController = LikeStorageViewController(reactor: reactor)
        viewController.containSongsFactory = containSongsFactory
        viewController.textPopupFactory = textPopupFactory
        viewController.signInFactory = signInFactory
        viewController.songDetailPresenter = songDetailPresenter
        return viewController
    }

    override func configureUI() {
        super.configureUI()
        reactor?.action.onNext(.viewDidLoad)
    }

    private func setTableView() {
        likeStorageView.tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }

    override func bindState(reactor: LikeStorageReactor) {
        super.bindState(reactor: reactor)
        let sharedState = reactor.state.share()

        sharedState.map(\.isLoggedIn)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isLoggedIn in
                owner.likeStorageView.updateIsHiddenLoginWarningView(isHidden: isLoggedIn)
            })
            .disposed(by: disposeBag)

        sharedState.map(\.isShowActivityIndicator)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isShow in
                owner.likeStorageView.updateActivityIndicatorState(isPlaying: isShow)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$hideSongCart)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                owner.hideSongCart()
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showToast)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, message in
                owner.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                    options: [.tabBar, .songCart]
                )
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showAddToPlaylistPopup)
            .compactMap { $0 }
            .bind(with: self) { owner, songs in
                let vc = owner.containSongsFactory.makeView(songs: songs)
                vc.modalPresentationStyle = .overFullScreen
                owner.present(vc, animated: true) {
                    owner.reactor?.action.onNext(.presentAddToPlaylistPopup)
                }
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$showDeletePopup)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, itemCount in
                guard let vc = owner.textPopupFactory.makeView(
                    text: "선택한 내 리스트 \(itemCount)개가 삭제됩니다.",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        owner.reactor?.action.onNext(.confirmDeleteButtonDidTap)
                    },
                    cancelCompletion: {}
                ) as? TextPopupViewController else {
                    return
                }
                owner.showBottomSheet(content: vc)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showLoginAlert)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let log = CommonAnalyticsLog.clickLoginButton(entry: .storageLike)
                LogManager.analytics(log)

                let loginVC = owner.signInFactory.makeView()
                loginVC.modalPresentationStyle = .fullScreen
                owner.present(loginVC, animated: true)
            })
            .disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            // .skip(1)
            .withUnretained(self)
            .withLatestFrom(Utility.PreferenceManager.$userInfo) { ($0.0, $0.1, $1) }
            .do(onNext: { owner, dataSource, _ in
                owner.likeStorageView.updateRefreshControlState(isPlaying: false)
                let dataSourceIsEmpty = dataSource.flatMap { $0.items }.isEmpty
                owner.likeStorageView.updateIsHiddenEmptyWarningView(isHidden: !dataSourceIsEmpty)
            })
            .map { $0.1 }
            .bind(to: likeStorageView.tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        sharedState.map(\.isEditing)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, flag in
                owner.likeStorageView.tableView.isEditing = flag
                owner.likeStorageView.tableView.reloadData()
                owner.likeStorageView.updateIsEnabledRefreshControl(isEnabled: !flag)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.selectedItemCount)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, count in
                if count == 0 {
                    self.hideSongCart()
                } else {
                    owner.showSongCart(
                        in: (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?
                            .rootViewController?.view ?? UIView(),
                        type: .likeSong,
                        selectedSongCount: count,
                        totalSongCount: owner.reactor?.currentState.dataSource.first?.items.count ?? 0,
                        useBottomSpace: true
                    )
                    owner.songCartView.delegate = owner
                }
            })
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: LikeStorageReactor) {
        super.bindAction(reactor: reactor)

        likeStorageView.rx.loginButtonDidTap
            .do(onNext: { LogManager.analytics(StorageAnalyticsLog.clickLoginButton(location: .myLikeList)) })
            .map { Reactor.Action.loginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        likeStorageView.rx.refreshControlValueChanged
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        likeStorageView.tableView.rx.itemMoved
            .map { Reactor.Action.itemMoved($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        likeStorageView.tableView.rx.itemSelected
            .withLatestFrom(reactor.state.map(\.dataSource)) { ($0, $1) }
            .compactMap { $0.1[safe: $0.0.section]?.items[safe: $0.0.row] }
            .bind(with: self, onNext: { owner, song in
                LogManager.analytics(StorageAnalyticsLog.clickMyLikeListMusicButton(id: song.songID))

                PlayState.shared.append(item: .init(id: song.songID, title: song.title, artist: song.artist))
                let playlistIDs = PlayState.shared.currentPlaylist
                    .map(\.id)
                owner.songDetailPresenter.present(ids: playlistIDs, selectedID: song.songID)
            })
            .disposed(by: disposeBag)
    }
}

extension LikeStorageViewController {
    private func createDatasources() -> RxTableViewSectionedReloadDataSource<LikeSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<LikeSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self, let reactor = self.reactor else { return UITableViewCell()
                }
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: LikeStorageTableViewCell.reuseIdentifer,
                    for: IndexPath(row: indexPath.row, section: 0)
                ) as? LikeStorageTableViewCell
                else { return UITableViewCell() }

                cell.update(
                    model: model,
                    isEditing: reactor.currentState.isEditing,
                    indexPath: indexPath
                )
                cell.delegate = self
                cell.selectionStyle = .none
                return cell

            },
            canEditRowAtIndexPath: { _, _ -> Bool in
                return true
            },
            canMoveRowAtIndexPath: { _, _ -> Bool in
                return true
            }
        )
        return datasource
    }
}

extension LikeStorageViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            reactor?.action.onNext(.tapAll(isSelecting: flag))
        case .addSong:
            let log = CommonAnalyticsLog.clickAddMusicsButton(location: .storageLike)
            LogManager.analytics(log)

            reactor?.action.onNext(.addToPlaylistButtonDidTap)
        case .addPlayList:
            reactor?.action.onNext(.addToCurrentPlaylistButtonDidTap)
        case .remove:
            reactor?.action.onNext(.deleteButtonDidTap)
        default: return
        }
    }
}

extension LikeStorageViewController: LikeStorageTableViewCellDelegate {
    public func buttonTapped(type: LikeStorageTableViewCellDelegateConstant) {
        switch type {
        case let .cellTapped(indexPath):
            self.reactor?.action.onNext(.songDidTap(indexPath.row))
        case let .playTapped(song):
            LogManager.analytics(CommonAnalyticsLog.clickPlayButton(location: .storageLike, type: .single))
            self.reactor?.action.onNext(.playDidTap(song: song))
        }
    }
}

extension LikeStorageViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }
}

extension LikeStorageViewController {
    func scrollToTop() {
        likeStorageView.tableView.setContentOffset(.zero, animated: true)
    }
}
