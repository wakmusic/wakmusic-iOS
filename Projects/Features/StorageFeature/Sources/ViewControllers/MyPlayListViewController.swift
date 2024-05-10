import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import NVActivityIndicatorView
import PanModal
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

final class MyPlayListViewController: BaseStoryboardReactorViewController<MyPlaylistReactor>, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!

    private var refreshControl = UIRefreshControl()
    var multiPurposePopUpFactory: MultiPurposePopUpFactory!
    var textPopUpFactory: TextPopUpFactory!
    var playlistDetailFactory: PlaylistDetailFactory!
    var signInFactory: SignInFactory!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared
    
    let header = MyPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    static func viewController(
        reactor: MyPlaylistReactor,
        multiPurposePopUpFactory: MultiPurposePopUpFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory
    ) -> MyPlayListViewController {
        let viewController = MyPlayListViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
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

        header.delegate = self
        self.tableView.tableHeaderView = header
  
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)

        self.activityIndicator.type = .circleStrokeSpin
        self.activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIndicator.startAnimating()

        reactor?.action.onNext(.viewDidLoad)
    }

    override func bind(reactor: MyPlaylistReactor) {
        super.bind(reactor: reactor)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MyPlaylistReactor) {
        super.bindAction(reactor: reactor)
        
        let currentState = reactor.state
        
        refreshControl.rx
            .controlEvent(.valueChanged)
            .map{ Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .withUnretained(self)
            .withLatestFrom(currentState.map(\.isEditing)){($0.0,$0.1,$1)}
            .withLatestFrom(currentState.map(\.dataSource)){($0.0,$0.1,$0.2,$1)}
            .bind { (owner, indexPath, isEditing,dataSource) in
                
                guard isEditing else {
                
                    owner.navigationController?.pushViewController(
                        owner.playlistDetailFactory.makeView(
                            id: dataSource[indexPath.section].items[indexPath.row].key,
                            isCustom: true), 
                        animated: true)
                    
                    return
                }
                
                
                // TODO: 상위로 전달
                
                
                
            }
            .disposed(by: disposeBag)
        
        
//        tableView.rx.itemSelected
//            .withLatestFrom(output.dataSource) { ($0, $1) }
//            .withLatestFrom(output.state) { ($0.0, $0.1, $1) }
//            .subscribe(onNext: { [weak self] indexPath, dataSource, state in
//                guard let self = self else { return }
//
//                let isEditing: Bool = state.isEditing
//
//                if isEditing { // 편집 중일 때, 동작 안함
//                    self.input.itemSelected.onNext(indexPath)
//
//                } else {
//                    let id: String = dataSource[indexPath.section].items[indexPath.row].key
//                    let vc = self.playlistDetailFactory.makeView(id: id, isCustom: true)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            })
//            .disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .map { Reactor.Action.itemMoved($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        
    }

    override func bindState(reactor: MyPlaylistReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share(replay: 2)

        
        
        sharedState.map(\.dataSource)
            .skip(1)
            .withUnretained(self)
            .withLatestFrom(Utility.PreferenceManager.$userInfo) { ($0.0, $0.1, $1) }
            .do(onNext: { owner, dataSource, userInfo in

                owner.activityIndicator.stopAnimating()
                owner.refreshControl.endRefreshing()

                guard let userInfo = userInfo else {
                    // 로그인 안되어있음
                    let view = owner.signInFactory.makeWarnigView(
                        CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: APP_HEIGHT() / 5),
                        text: "로그인 하고\n리스트를 확인해보세요."
                    ) {
                        // TODO: 로그인 팝업 요청 (아마 StorageVC로 가야할 듯?
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
            .bind { (owner, flag) in
                
                owner.tableView.tableHeaderView = flag ? nil : owner.header
                owner.tableView.isEditing = flag
                owner.tableView.reloadData()
            }
            .disposed(by: disposeBag)
        
        
        
    }

    // extension MyPlayListViewController {
//    private func inputBindRx() {

//
//        tableView.rx.itemSelected
//            .withLatestFrom(output.dataSource) { ($0, $1) }
//            .withLatestFrom(output.state) { ($0.0, $0.1, $1) }
//            .subscribe(onNext: { [weak self] indexPath, dataSource, state in
//                guard let self = self else { return }
//
//                let isEditing: Bool = state.isEditing
//
//                if isEditing { // 편집 중일 때, 동작 안함
//                    self.input.itemSelected.onNext(indexPath)
//
//                } else {
//                    let id: String = dataSource[indexPath.section].items[indexPath.row].key
//                    let vc = self.playlistDetailFactory.makeView(id: id, isCustom: true)
//                    self.navigationController?.pushViewController(vc, animated: true)
//                }
//            })
//            .disposed(by: disposeBag)
//
//        tableView.rx.itemMoved
//            .debug("itemMoved")
//            .bind(to: input.itemMoved)
//            .disposed(by: disposeBag)
//    }

//    private func outputBindRx() {
//        output.state
//            .skip(1)
//            .subscribe(onNext: { [weak self] state in
//                guard let self = self else {
//                    return
//                }
//                if state.isEditing == false && state.force == false { // 정상적인 편집 완료 이벤트
//                    self.input.runEditing.onNext(())
//                }

    // TODO: Storage 리팩 후

//                guard let parent = self.parent?.parent as? AfterLoginViewController else {
//                    return
//                }
//
//                // 탭맨 쪽 편집 변경
//                let isEdit: Bool = state.isEditing
//                parent.output.state.accept(EditState(isEditing: isEdit, force: true))
//                self.tableView.refreshControl = isEdit ? nil : self.refreshControl
//                self.tableView.setEditing(isEdit, animated: true)
//
//                let header = MyPlayListHeaderView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 140))
//                header.delegate = self
//                self.tableView.tableHeaderView = isEdit ? nil : header
//                self.tableView.reloadData()
//            })
//            .disposed(by: disposeBag)
//
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
//
//        output.dataSource
//            .skip(1)
//            .do(onNext: { [weak self] model in
//                guard let self = self else {
//                    return
//                }
//                self.refreshControl.endRefreshing()
//                self.activityIndicator.stopAnimating()
//
//                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 3))
//                warningView.text = "내 리스트가 없습니다."
//
//                let items = model.first?.items ?? []
//                self.tableView.tableFooterView = items.isEmpty ? warningView : UIView(frame: CGRect(
//                    x: 0,
//                    y: 0,
//                    width: APP_WIDTH(),
//                    height: 56
//                ))
//            })
//            .bind(to: tableView.rx.items(dataSource: createDatasources()))
//            .disposed(by: disposeBag)
//
//        output.indexPathOfSelectedPlayLists
//            .skip(1)
//            .debug("indexPathOfSelectedPlayLists")
//            .withLatestFrom(output.dataSource) { ($0, $1) }
//            .subscribe(onNext: { [weak self] songs, dataSource in
//                guard let self = self else { return }
//                let items = dataSource.first?.items ?? []
//
//                switch songs.isEmpty {
//                case true:
//                    self.hideSongCart()
//                case false:
//                    self.showSongCart(
//                        in: UIApplication.shared.windows.first?.rootViewController?.view ?? UIView(),
//                        type: .myList,
//                        selectedSongCount: songs.count,
//                        totalSongCount: items.count,
//                        useBottomSpace: true
//                    )
//                    self.songCartView?.delegate = self
//                }
//            }).disposed(by: disposeBag)
//
//        output.willAddPlayList
//            .skip(1)
//            .debug("willAddPlayList")
//            .subscribe(onNext: { [weak self] songs in
//                guard let self = self else { return }
//                if !songs.isEmpty {
//                    self.playState.appendSongsToPlaylist(songs)
//                }
//                self.input.allPlayListSelected.onNext(false)
//                self.output.state.accept(EditState(isEditing: false, force: true))
//                let message: String = songs.isEmpty ?
//                    "리스트에 곡이 없습니다." :
//                    "\(songs.count)곡이 재생목록에 추가되었습니다. 중복 곡은 제외됩니다."
//                self.showToast(
//                    text: message,
//                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
//                )
//            }).disposed(by: disposeBag)
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

extension MyPlayListViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
//        switch type {
//        case let .allSelect(flag):
//            input.allPlayListSelected.onNext(flag)
//
//        case .addPlayList:
//            input.addPlayList.onNext(())
//            self.hideSongCart()
//
//        case .remove:
//            let count: Int = output.indexPathOfSelectedPlayLists.value.count
//
//            guard let textPopupViewController = self.textPopUpFactory.makeView(
//                text: "선택한 내 리스트 \(count)개가 삭제됩니다.",
//                cancelButtonIsHidden: false,
//                allowsDragAndTapToDismiss: nil,
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
//
//        default: return
//        }
    }
}

extension MyPlayListViewController: MyPlayListTableViewCellDelegate {
    public func buttonTapped(type: MyPlayListTableViewCellDelegateConstant) {
//        switch type {
//        case let .listTapped(indexPath):
//            input.itemSelected.onNext(indexPath)
//        case let .playTapped(indexPath):
//            let songs: [SongEntity] = output.dataSource.value[indexPath.section].items[indexPath.row].songlist
//            guard !songs.isEmpty else {
//                self.showToast(
//                    text: "리스트에 곡이 없습니다.",
//                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14)
//                )
//                return
//            }
//            self.playState.loadAndAppendSongsToPlaylist(songs)
//        }
    }
}

extension MyPlayListViewController: UITableViewDelegate {
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

extension MyPlayListViewController: MyPlayListHeaderViewDelegate {
    public func action(_ type: PurposeType) {
        
        guard let userInfo =  Utility.PreferenceManager.userInfo else {
            
            guard let vc = self.textPopUpFactory.makeView(
                text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                cancelButtonIsHidden: false,
                allowsDragAndTapToDismiss: nil,
                confirmButtonText: nil,
                cancelButtonText: nil,
                completion: { [weak self]  in
                    
                    guard let self else {return}
                    
                    let loginVC = self.signInFactory.makeView()
                    self.present(loginVC, animated: true)
                },
                cancelCompletion: {}
            ) as? TextPopupViewController else {
                return
            }
            
            self.showPanModal(content: vc)
            
            return
        }
        
        
        // TODO: Storage 리팩 후
//        if let parent = self.parent?.parent as? AfterLoginViewController {
//            parent.hideEditSheet()
//            parent.profileButton.isSelected = false
//        }
//        let vc = multiPurposePopUpFactory
//            .makeView(type: type, key: "", completion: nil)
//        self.showEntryKitModal(content: vc, height: 296)
    }
}

extension MyPlayListViewController {
    func scrollToTop() {
//        let itemIsEmpty: Bool = output.dataSource.value.first?.items.isEmpty ?? true
//        guard !itemIsEmpty else { return }
//        tableView.setContentOffset(.zero, animated: true)
    }
}
