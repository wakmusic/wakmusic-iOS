import BaseFeature
import BaseFeatureInterface
import DesignSystem
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

typealias MyPlayListSectionModel = SectionModel<Int, PlayListEntity>

final class PlaylistStorageViewController: BaseStoryboardReactorViewController<PlaylistStorageReactor>,
    SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private var refreshControl = UIRefreshControl()
    var multiPurposePopUpFactory: MultiPurposePopupFactory!
    var textPopUpFactory: TextPopUpFactory!
    var playlistDetailFactory: PlaylistDetailFactory!
    var signInFactory: SignInFactory!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    static func viewController(
        reactor: PlaylistStorageReactor,
        multiPurposePopUpFactory: MultiPurposePopupFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory
    ) -> PlaylistStorageViewController {
        let viewController = PlaylistStorageViewController.viewController(
            storyBoardName: "Storage",
            bundle: Bundle.module
        )
        viewController.reactor = reactor
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.playlistDetailFactory = playlistDetailFactory
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    override func configureUI() {
        super.configureUI()

        self.tableView.refreshControl = self.refreshControl

        #warning("tableview 헤더로 리스트 만들기 버튼")

        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)

        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()

        reactor?.action.onNext(.viewDidLoad)
    }

    override func bind(reactor: PlaylistStorageReactor) {
        super.bind(reactor: reactor)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: PlaylistStorageReactor) {
        super.bindAction(reactor: reactor)

        let currentState = reactor.state

        refreshControl.rx
            .controlEvent(.valueChanged)
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
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

        tableView.rx.itemMoved
            .map { Reactor.Action.itemMoved($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: PlaylistStorageReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share(replay: 3)

        sharedState.map(\.dataSource)
            .skip(1)
            .withUnretained(self)
            .withLatestFrom(Utility.PreferenceManager.$userInfo) { ($0.0, $0.1, $1) }
            .do(onNext: { owner, dataSource, userInfo in

                owner.activityIndicator.stopAnimating()
                owner.refreshControl.endRefreshing()

                guard let userInfo = userInfo else {
                    // 로그인 안되어있음

                    let view = LoginWarningView(
                        frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: APP_HEIGHT() / 5),
                        text: "로그인 하고\n리스트를 확인해보세요."
                    ) {
                        // TODO: 로그인 팝업 요청 (아마 StorageVC로 가야할 듯?
                        LogManager.printDebug("TAP 로그인 버튼")
                    }

                    owner.tableView.tableFooterView = view
                    return
                }

                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 3))
                warningView.text = "내 리스트가 없습니다."

                let items = dataSource.first?.items ?? []
                owner.tableView.tableFooterView = items.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: 56
                ))
            })
            .map { $0.1 }
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        sharedState.map(\.isEditing)
            .withUnretained(self)
            .bind { owner, flag in

                owner.tableView.isEditing = flag
                owner.tableView.reloadData()
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

    // extension MyPlayListViewController {

//
//        output.showToast
//            .subscribe(onNext: { [weak self] result in
//                guard let self = self else {
//                    return
//                }
//
//                self.showToast(
//                    text: result.description,
//                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
//                )
//            })
//            .disposed(by: disposeBag)
//
//        output.onLogout.bind(with: self) { owner, error in
//            NotificationCenter.default.post(name: .movedTab, object: 4)
//            owner.showToast(
//                text: error.localizedDescription,
//                font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
//            )
//        }
//        .disposed(by: disposeBag)
//    }

    private func createDatasources() -> RxTableViewSectionedReloadDataSource<MyPlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<MyPlayListSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self, let reactor = self.reactor else { return UITableViewCell() }

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "MyPlayListTableViewCell",
                    for: IndexPath(row: indexPath.row, section: 0)
                ) as? MyPlayListTableViewCell
                else { return UITableViewCell() }

                cell.update(
                    model: model,
                    isEditing: reactor.currentState.isEditing,
                    indexPath: indexPath
                )
                cell.delegate = self
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

extension PlaylistStorageViewController: SongCartViewDelegate {
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

extension PlaylistStorageViewController: MyPlayListTableViewCellDelegate {
    public func buttonTapped(type: MyPlayListTableViewCellDelegateConstant) {
        switch type {
        case let .listTapped(indexPath):
            self.reactor?.action.onNext(.playlistDidTap(indexPath.row))
        case let .playTapped(indexPath):
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

extension PlaylistStorageViewController: UITableViewDelegate {
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

extension PlaylistStorageViewController {
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
