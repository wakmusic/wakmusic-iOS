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

final class NewPlaylistStorageViewController: BaseReactorViewController<PlaylistStorageReactor>, SongCartViewType {
    let playlistStorageView = PlaylistStorageView()

    var multiPurposePopUpFactory: MultiPurposePopupFactory!
    var textPopUpFactory: TextPopUpFactory!
    var playlistDetailFactory: PlaylistDetailFactory!
    var signInFactory: SignInFactory!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    override func loadView() {
        self.view = playlistStorageView
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }

    static func viewController(
        reactor: PlaylistStorageReactor,
        multiPurposePopUpFactory: MultiPurposePopupFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory
    ) -> NewPlaylistStorageViewController {
        let viewController = NewPlaylistStorageViewController(reactor: reactor)
        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.playlistDetailFactory = playlistDetailFactory
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    override func configureUI() {
        reactor?.action.onNext(.viewDidLoad)
    }

    private func setTableView() {
        playlistStorageView.tableView.delegate = self
    }

    override func bindState(reactor: PlaylistStorageReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        sharedState.map(\.dataSource)
            .skip(1)
            .withUnretained(self)
            .withLatestFrom(Utility.PreferenceManager.$userInfo) { ($0.0, $0.1, $1) }
            .do(onNext: { owner, dataSource, userInfo in

                owner.playlistStorageView.updateActivityIndicatorState(isPlaying: false)
                owner.playlistStorageView.refreshControl.endRefreshing()
                owner.playlistStorageView.updateEmptyWarningViewState(isShow: dataSource.isEmpty)

            })
            .map { $0.1 }
            .bind(to: playlistStorageView.tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        sharedState.map(\.isEditing)
            .withUnretained(self)
            .bind { owner, flag in

                owner.playlistStorageView.tableView.isEditing = flag
                owner.playlistStorageView.tableView.reloadData()
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

    override func bindAction(reactor: PlaylistStorageReactor) {
        let currentState = reactor.state

        playlistStorageView.rx.refreshControlValueChanged
            .map { Reactor.Action.refresh }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        playlistStorageView.tableView.rx.itemSelected
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

        playlistStorageView.tableView.rx.itemMoved
            .map { Reactor.Action.itemMoved($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }

    private func createDatasources() -> RxTableViewSectionedReloadDataSource<MyPlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<MyPlayListSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self, let reactor = self.reactor else { return UITableViewCell() }

                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: MyPlaylistTableViewCell.reuseIdentifer,
                    for: IndexPath(row: indexPath.row, section: 0)
                ) as? MyPlaylistTableViewCell
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

extension NewPlaylistStorageViewController: SongCartViewDelegate {
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

extension NewPlaylistStorageViewController: MyPlaylistTableViewCellDelegate {
    public func buttonTapped(type: MyPlaylistTableViewCellDelegateConstant) {
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

extension NewPlaylistStorageViewController: UITableViewDelegate {
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

extension NewPlaylistStorageViewController {
    func scrollToTop() {
        playlistStorageView.tableView.setContentOffset(.zero, animated: true)
    }
}
