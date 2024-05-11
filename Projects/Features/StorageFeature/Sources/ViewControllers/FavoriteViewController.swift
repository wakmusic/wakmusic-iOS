import BaseDomainInterface
import BaseFeature
import BaseFeatureInterface
import DesignSystem
import NVActivityIndicatorView
import RxDataSources
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import UserDomainInterface
import Utility
import SignInFeatureInterface
import LogManager

typealias FavoriteSectionModel = SectionModel<Int, FavoriteSongEntity>

final class FavoriteViewController: BaseStoryboardReactorViewController<FavoriteReactoer>, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private var refreshControl = UIRefreshControl()

    var containSongsFactory: ContainSongsFactory!
    var textPopUpFactory: TextPopUpFactory!
    var signInFactory: SignInFactory!


     var songCartView: SongCartView!
    var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    static func viewController(
        reactor: FavoriteReactoer,
        containSongsFactory: ContainSongsFactory,
        textPopUpFactory: TextPopUpFactory,
        signInFactory:SignInFactory
    ) -> FavoriteViewController {
        let viewController = FavoriteViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        viewController.reactor = reactor
        viewController.containSongsFactory = containSongsFactory
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }
    
    override func configureUI() {
        super.configureUI()
        
        self.tableView.refreshControl = self.refreshControl
        self.view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.tableView.backgroundColor = .clear
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)
        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()
        
        reactor?.action.onNext(.viewDidLoad)
    }
    
    override func bind(reactor: FavoriteReactoer) {
        super.bind(reactor: reactor)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    override func bindAction(reactor: FavoriteReactoer) {
        super.bindAction(reactor: reactor)
        
        let currentState = reactor.state
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .withLatestFrom(currentState.map(\.isEditing)) { ($0.0, $0.1, $1) }
            .withLatestFrom(currentState.map(\.dataSource)) { ($0.0, $0.1, $0.2, $1) }
            .bind { owner, indexPath, isEditing, dataSource in

                guard isEditing else {
                    
                    //TODO: 아마 곡 상세로 이동?

                    return
                }
            }
            .disposed(by: disposeBag)

        tableView.rx.itemMoved
            .map { Reactor.Action.itemMoved($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
    }
    
    override func bindState(reactor: FavoriteReactoer) {
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
                warningView.text = "좋아요 한 곡이 없습니다."

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
                        in: UIApplication.shared.windows.first?.rootViewController?.view ?? UIView(),
                        type: .likeSong,
                        selectedSongCount: count,
                        totalSongCount: owner.reactor?.currentState.dataSource.first?.items.count ?? 0,
                        useBottomSpace: true
                    )
                    owner.songCartView?.delegate = owner
                }

            })
            .disposed(by: disposeBag)
        
    }
    
}

extension FavoriteViewController {

    private func createDatasources() -> RxTableViewSectionedReloadDataSource<FavoriteSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<FavoriteSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self, let reactor = self.reactor else { return UITableViewCell()
                }
                guard let cell = tableView.dequeueReusableCell(
                      withIdentifier: "FavoriteTableViewCell",
                      for: IndexPath(row: indexPath.row, section: 0)
                ) as? FavoriteTableViewCell
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

extension FavoriteViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            reactor?.action.onNext(.tapAll(isSelecting: flag))
        case .addSong:
//            input.addSongs.onNext(())
            self.hideSongCart()
        case .addPlayList:
            // input.addPlayList.onNext(())
            self.hideSongCart()
        case .remove:
            break
            // TODO: useCase 연결 후
//            let count: Int = output.indexPathOfSelectedLikeLists.value.count
//
//            guard let textPopupViewController = self.textPopUpFactory.makeView(
//                text: "선택한 좋아요 리스트 \(count)곡이 삭제됩니다.?",
//                cancelButtonIsHidden: false,
//                allowsDragAndTapToDismiss: nil,
//                confirmButtonText: nil,
//                cancelButtonText: nil,
//                completion: { [weak self] in
//
//                    guard let self else { return }
//                    self.input.deleteLikeList.onNext(())
//                    self.hideSongCart()
//
//                },
//                cancelCompletion: nil
//            ) as? TextPopupViewController else {
//                return
//            }

//self.showPanModal(content: textPopupViewController)
        default: return
        }
    }
}

extension FavoriteViewController: FavoriteTableViewCellDelegate {
    public func buttonTapped(type: FavoriteTableViewCellDelegateConstant) {
        switch type {
        case let .listTapped(indexPath):
            self.reactor?.action.onNext(.songDidTap(indexPath.row))
        case let .playTapped(song):
            // TODO: useCase 연결 후
            break
        }
    }
}

extension FavoriteViewController: UITableViewDelegate {
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

extension FavoriteViewController {
    func scrollToTop() {
        tableView.setContentOffset(.zero, animated: true)
    }
}
