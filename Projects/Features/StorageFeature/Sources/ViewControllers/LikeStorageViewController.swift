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

final class LikeStorageViewController: BaseReactorViewController<LikeStorageReactor>, SongCartViewType {
    let likeStorageView = LikeStorageView()
    
    var containSongsFactory: ContainSongsFactory!
    var textPopUpFactory: TextPopUpFactory!
    var signInFactory: SignInFactory!

    var songCartView: SongCartView!
    var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared

    override func loadView() {
        super.loadView()
        self.view = likeStorageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    static func viewController(
        reactor: Reactor,
        containSongsFactory: ContainSongsFactory,
        textPopUpFactory: TextPopUpFactory,
        signInFactory: SignInFactory
    ) -> LikeStorageViewController {
        let viewController = LikeStorageViewController(reactor: reactor)
        viewController.containSongsFactory = containSongsFactory
        viewController.textPopUpFactory = textPopUpFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    override func configureUI() {
        super.configureUI()

        reactor?.action.onNext(.viewDidLoad)
    }

    private func setTableView() {
        likeStorageView.tableView.delegate = self
    }

    override func bindState(reactor: LikeStorageReactor) {
        super.bindState(reactor: reactor)
        let sharedState = reactor.state.share()

    }
    
    override func bindAction(reactor: LikeStorageReactor) {
        super.bindAction(reactor: reactor)

    }
    
}

extension LikeStorageViewController {
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

extension LikeStorageViewController: SongCartViewDelegate {
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

        // self.showBottomSheet(content: textPopupViewController)
        default: return
        }
    }
}

extension LikeStorageViewController: FavoriteTableViewCellDelegate {
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
