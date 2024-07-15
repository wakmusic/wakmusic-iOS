import BaseFeature
import BaseFeatureInterface
import DesignSystem
import FruitDrawFeatureInterface
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

typealias MyPlayListSectionModel = SectionModel<Int, PlaylistEntity>

final class ListStorageViewController: BaseReactorViewController<ListStorageReactor>, SongCartViewType,
    PlaylistDetailNavigator {
    let listStorageView = ListStorageView()

    var multiPurposePopUpFactory: MultiPurposePopupFactory
    var textPopUpFactory: TextPopUpFactory
    var playlistDetailFactory: any PlaylistDetailFactory
    var signInFactory: SignInFactory
    var fruitDrawFactory: FruitDrawFactory
    var songCartView: SongCartView!
    var bottomSheetView: BottomSheetView!

    init(
        reactor: Reactor,
        multiPurposePopUpFactory: MultiPurposePopupFactory,
        textPopUpFactory: TextPopUpFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        signInFactory: SignInFactory,
        fruitDrawFactory: FruitDrawFactory
    ) {
        self.multiPurposePopUpFactory = multiPurposePopUpFactory
        self.textPopUpFactory = textPopUpFactory
        self.playlistDetailFactory = playlistDetailFactory
        self.signInFactory = signInFactory
        self.fruitDrawFactory = fruitDrawFactory
        super.init(reactor: reactor)
    }

    override func loadView() {
        self.view = listStorageView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    override func configureUI() {
        reactor?.action.onNext(.viewDidLoad)
    }

    private func setTableView() {
        listStorageView.tableView.delegate = self
    }

    override func bindState(reactor: ListStorageReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.isLoggedIn)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isLoggedIn in
                owner.listStorageView.updateIsHiddenLoginWarningView(isHidden: isLoggedIn)
            })
            .disposed(by: disposeBag)

        sharedState.map(\.isShowActivityIndicator)
            .distinctUntilChanged()
            .bind(with: self, onNext: { owner, isShow in
                owner.listStorageView.updateActivityIndicatorState(isPlaying: isShow)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showDetail)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, detailInfo in
                let key = detailInfo.key
                let isMine = detailInfo.isMine
                owner.navigatePlaylistDetail(key: key, kind: isMine ? .my : .unknown)
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
                owner.showToast(text: message, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showDrawFruitPopup)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, message in
                let vc = owner.fruitDrawFactory.makeView(delegate: owner)
                vc.modalPresentationStyle = .fullScreen
                owner.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showCreateListPopup)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, _ in
                let vc = owner.multiPurposePopUpFactory.makeView(type: .creation, key: "") { title in
                    owner.reactor?.action.onNext(.confirmCreateListButtonDidTap(title))
                }
                owner.showBottomSheet(content: vc, size: .fixed(296))
            })
            .disposed(by: disposeBag)

        reactor.pulse(\.$showDeletePopup)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, itemCount in
                guard let vc = owner.textPopUpFactory.makeView(
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
                guard let vc = owner.textPopUpFactory.makeView(
                    text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let loginVC = owner.signInFactory.makeView()
                        loginVC.modalPresentationStyle = .fullScreen
                        owner.present(loginVC, animated: true)
                    },
                    cancelCompletion: {}
                ) as? TextPopupViewController else {
                    return
                }
                owner.showBottomSheet(content: vc)
            })
            .disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            // .skip(1)
            .withUnretained(self)
            .withLatestFrom(Utility.PreferenceManager.$userInfo) { ($0.0, $0.1, $1) }
            .do(onNext: { owner, dataSource, _ in
                owner.listStorageView.updateRefreshControlState(isPlaying: false)
                let dataSourceIsEmpty = dataSource.flatMap { $0.items }.isEmpty
                owner.listStorageView.updateIsHiddenEmptyWarningView(isHidden: !dataSourceIsEmpty)
            })
            .map { $0.1 }
            .bind(to: listStorageView.tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        sharedState.map(\.isEditing)
            .distinctUntilChanged()
            .withUnretained(self)
            .bind { owner, flag in
                owner.listStorageView.tableView.isEditing = flag
                owner.listStorageView.tableView.reloadData()
                owner.listStorageView.updateIsEnabledRefreshControl(isEnabled: !flag)
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
                        type: .playlistStorage,
                        selectedSongCount: count,
                        totalSongCount: owner.reactor?.currentState.dataSource.first?.items.count ?? 0,
                        useBottomSpace: true
                    )
                    owner.songCartView.delegate = owner
                }
            })
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: ListStorageReactor) {
        let currentState = reactor.state

        listStorageView.rx.loginButtonDidTap
            .map { Reactor.Action.loginButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        listStorageView.rx.refreshControlValueChanged
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        listStorageView.rx.drawFruitButtonDidTap
            .map { Reactor.Action.drawFruitButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        listStorageView.rx.createListButtonDidTap
            .map { Reactor.Action.createListButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        listStorageView.tableView.rx.itemMoved
            .map { Reactor.Action.itemMoved($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func createDatasources() -> RxTableViewSectionedReloadDataSource<MyPlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<MyPlayListSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self, let reactor = self.reactor else { return UITableViewCell() }

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: ListStorageTableViewCell.reuseIdentifer,
                    for: IndexPath(row: indexPath.row, section: 0)
                ) as? ListStorageTableViewCell
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

extension ListStorageViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            reactor?.action.onNext(.tapAll(isSelecting: flag))

        case .addPlayList:
            reactor?.action.onNext(.addToCurrentPlaylistButtonDidTap)

        case .remove:
            reactor?.action.onNext(.deleteButtonDidTap)

        default: return
        }
    }
}

extension ListStorageViewController: ListStorageTableViewCellDelegate {
    public func buttonTapped(type: ListStorageTableViewCellDelegateConstant) {
        switch type {
        case let .listTapped(indexPath):
            self.reactor?.action.onNext(.listDidTap(indexPath))

        case let .playTapped(indexPath):
            self.reactor?.action.onNext(.playDidTap(indexPath.row))

        case let .cellTapped(indexPath):
            self.reactor?.action.onNext(.cellDidTap(indexPath.row))
        }
    }
}

extension ListStorageViewController: UITableViewDelegate {
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

extension ListStorageViewController {
    func scrollToTop() {
        listStorageView.tableView.setContentOffset(.zero, animated: true)
    }
}

extension ListStorageViewController: FruitDrawViewControllerDelegate {
    func completedFruitDraw(itemCount: Int) {
        #warning("획득한 열매 갯수입니다. 다음 처리 진행해주세요.")
        LogManager.printDebug("itemCount: \(itemCount)")
    }
}
