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

final class ListStorageViewController: BaseReactorViewController<ListStorageReactor>, SongCartViewType {
    let listStorageView = ListStorageView()

    var multiPurposePopUpFactory: MultiPurposePopupFactory!
    var textPopUpFactory: TextPopUpFactory!
    var playlistDetailFactory: PlaylistDetailFactory!
    var signInFactory: SignInFactory!
    var fruitDrawFactory: FruitDrawFactory!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    override func loadView() {
        self.view = listStorageView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    static func viewController(
        reactor: ListStorageReactor,
        multiPurposePopUpFactory: MultiPurposePopupFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory,
        fruitDrawFactory: FruitDrawFactory
    ) -> ListStorageViewController {
        let viewController = ListStorageViewController(reactor: reactor)
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.playlistDetailFactory = playlistDetailFactory
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        viewController.fruitDrawFactory = fruitDrawFactory
        return viewController
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

        reactor.pulse(\.$showToast)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, message in
                owner.showToast(text: message, font: DesignSystemFontFamily.Pretendard.light.font(size: 14))
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
            .do(onNext: { owner, dataSource, userInfo in
                print("🚀 dataSource changed", dataSource.count)
                // owner.listStorageView.updateActivityIndicatorState(isPlaying: false)
                owner.listStorageView.updateRefreshControlState(isPlaying: false)
            })
            .map { $0.1 }
            .bind(to: listStorageView.tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        sharedState.map(\.isEditing)
            .withUnretained(self)
            .bind { owner, flag in
                print("🚀 isEditing changed", flag)
                owner.listStorageView.tableView.isEditing = flag
                owner.listStorageView.tableView.reloadData()
                owner.listStorageView.updateIsEnabledRefreshControl(isEnabled: !flag)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.selectedItemCount)
            .withUnretained(self)
            .bind(onNext: { owner, count in

                if count == 0 {
                    owner.hideSongCart()
                } else {
                    owner.showSongCart(
                        in: (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?
                            .rootViewController?.view ?? UIView(),
                        type: .myList,
                        selectedSongCount: count,
                        totalSongCount: owner.reactor?.currentState.dataSource.first?.items.count ?? 0,
                        useBottomSpace: true
                    )
                    owner.songCartView?.delegate = owner
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
            .bind(onNext: { [weak self] _ in
                guard let self else { return }
                let vc = self.fruitDrawFactory.makeView(delegate: self)
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            })
            .disposed(by: disposeBag)

        listStorageView.rx.createListButtonDidTap
            .map { Reactor.Action.createListButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        listStorageView.tableView.rx.itemSelected
            .withUnretained(self)
            .withLatestFrom(currentState.map(\.isEditing)) { ($0.0, $0.1, $1) }
            .withLatestFrom(currentState.map(\.dataSource)) { ($0.0, $0.1, $0.2, $1) }
            .bind { owner, indexPath, isEditing, dataSource in

                guard isEditing else {
                    owner.navigationController?.pushViewController(
                        owner.playlistDetailFactory.makeView(
                            id: dataSource[indexPath.section].items[indexPath.row].key,
                            isCustom: true
                        ),
                        animated: true
                    )
                    return
                }
            }
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
            // input.addPlayList.onNext(())
            self.hideSongCart()

        case .remove:
            // TODO: useCase 연결 후
            break
//            let count: Int = output.indexPathOfSelectedPlayLists.value.count
//
//            guard let textPopupViewController = self.textPopUpFactory.makeView(
//                text: "선택한 내 리스트 \(count)개가 삭제됩니다.",
//                cancelButtonIsHidden: false,
//                confirmButtonText: nil,
//                cancelButtonText: nil,
//                completion: { [weak self] in
//
//                    guard let self else { return }
//                    self.input.deletePlayList.onNext(())
//                    self.hideSongCart()
//
//                },
//                cancelCompletion: nil
//            ) as? TextPopupViewController else {
//                return
//            }

        default: return
        }
    }
}

extension ListStorageViewController: ListStorageTableViewCellDelegate {
    public func buttonTapped(type: ListStorageTableViewCellDelegateConstant) {
        switch type {
        case let .listTapped(indexPath):
            print("🚀 리스트부분 터치", indexPath.row)
            self.reactor?.action.onNext(.playlistDidTap(indexPath.row))
        case let .playTapped(indexPath):
            print("🚀 버튼부분 터치", indexPath.row)
            // TODO: useCase 연결 후
            break
//            let songs: [SongEntity] = output.dataSource.value[indexPath.section].items[indexPath.row].songlist
//            guard !songs.isEmpty else {
//                self.showToast(
//                    text: "리스트에 곡이 없습니다.",
//                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
//                )
//                return
//            }
//            self.playState.loadAndAppendSongsToPlaylist(songs)
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
