import BaseFeature
import BaseFeatureInterface
import Combine
import DesignSystem
import Foundation
import Kingfisher
import LogManager
import RxDataSources
import RxRelay
import RxSwift
import SignInFeatureInterface
import SnapKit
import UIKit
import Utility

public final class PlaylistViewController: UIViewController, SongCartViewType {
    var viewModel: PlaylistViewModel!
    var playlistView: PlaylistView!
    var playState = PlayState.shared
    var subscription = Set<AnyCancellable>()
    var disposeBag = DisposeBag()

    var tappedCellIndex = PublishSubject<Int>()
    var isSelectedAllSongs = PublishSubject<Bool>()
    var tappedAddPlaylist = PublishSubject<Void>()
    var tappedRemoveSongs = PublishSubject<Void>()
    var didLongPressedSongSubject = PublishSubject<Int>()
    var didTapSwippedRemoveSongSubject = PublishSubject<Int>()

    private(set) var containSongsFactory: any ContainSongsFactory
    private(set) var songDetailPresenter: any SongDetailPresentable
    private(set) var textPopupFactory: any TextPopupFactory
    private(set) var signInFactory: any SignInFactory

    public var songCartView: BaseFeature.SongCartView!
    public var bottomSheetView: BaseFeature.BottomSheetView!

    private lazy var panGestureRecognizer = UIPanGestureRecognizer(
        target: self,
        action: #selector(handlePanGesture(_:))
    )

    lazy var input = PlaylistViewModel.Input(
        viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
        viewWillDisappearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillDisappear(_:))).map { _ in },
        closeButtonDidTapEvent: playlistView.closeButton.tapPublisher,
        editButtonDidTapEvent: playlistView.editButton.tapPublisher,
        playlistTableviewCellDidTapEvent: playlistView.playlistTableView.rx.itemSelected.asObservable(),
        playlistTableviewCellDidTapInEditModeEvent: tappedCellIndex.asObservable(),
        selectAllSongsButtonDidTapEvent: isSelectedAllSongs.asObservable(),
        addPlaylistButtonDidTapEvent: tappedAddPlaylist.asObservable(),
        removeSongsButtonDidTapEvent: tappedRemoveSongs.asObservable(),
        itemMovedEvent: playlistView.playlistTableView.rx.itemMoved.asObservable(),
        didLongPressedSongEvent: didLongPressedSongSubject,
        didTapSwippedRemoveButtonEvent: didTapSwippedRemoveSongSubject
    )
    lazy var output = self.viewModel.transform(from: input)

    private let currentSongID: String?

    init(
        currentSongID: String?,
        viewModel: PlaylistViewModel,
        containSongsFactory: ContainSongsFactory,
        songDetailPresenter: any SongDetailPresentable,
        textPopupFactory: any TextPopupFactory,
        signInFactory: any SignInFactory
    ) {
        self.currentSongID = currentSongID
        self.containSongsFactory = containSongsFactory
        self.songDetailPresenter = songDetailPresenter
        self.signInFactory = signInFactory
        self.textPopupFactory = textPopupFactory
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        LogManager.printDebug("❌ PlaylistVC deinit")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("PlaylistViewController has not been implemented")
    }

    override public func loadView() {
        super.loadView()
        playlistView = PlaylistView(frame: self.view.frame)
        self.view.addSubview(playlistView)
        self.playlistView.titleBarView.addGestureRecognizer(panGestureRecognizer)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        playlistView.playlistTableView.rx.setDelegate(self).disposed(by: disposeBag)
        playlistView.playlistTableView.dragDelegate = self
//        playlistView.playlistTableView.dragInteractionEnabled = true
        bindViewModel()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let log = CommonAnalyticsLog.viewPage(pageName: .playlist)
        LogManager.analytics(log)
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Comment: 재생목록 화면이 사라지는 시점에서 DB에 저장된 리스트로 업데이트
        // 편집 완료를 했으면 이미 DB가 업데이트 됐을거고, 아니면 이전 DB데이터로 업데이트
        // Comment: 재생목록 화면이 사라지는 시점에서 곡 담기 팝업이 올라와 있는 상태면 제거
        guard self.songCartView != nil else { return }
        self.hideSongCart()
    }
}

private extension PlaylistViewController {
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let distance = gestureRecognizer.translation(in: self.view)
        let screenHeight = Utility.APP_HEIGHT()

        switch gestureRecognizer.state {
        case .began:
            return

        case .changed:
            let distanceY = max(distance.y, 0)
            view.frame = CGRect(x: 0, y: distanceY, width: view.frame.width, height: screenHeight)

        case .ended:
            let velocity = gestureRecognizer.velocity(in: self.view)

            // 빠르게 드래그하거나 화면의 40% 이상 드래그 했을 경우 dismiss
            if velocity.y > 1000 || view.frame.origin.y > (screenHeight * 0.4) {
                dismiss(animated: true)
            } else {
                UIView.animate(
                    withDuration: 0.35,
                    delay: 0.0,
                    usingSpringWithDamping: 0.8,
                    initialSpringVelocity: 0.8,
                    options: [.curveEaseInOut],
                    animations: {
                        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: screenHeight)
                    }
                )
            }

        default:
            break
        }
    }
}

private extension PlaylistViewController {
    private func bindViewModel() {
        bindCountOfSongs(output: output)
        bindPlaylistTableView(output: output)
        bindSongCart(output: output)
        bindCloseButton(output: output)
    }

    private func bindCountOfSongs(output: PlaylistViewModel.Output) {
        output.countOfSongs.sink { [weak self] count in
            guard let self else { return }
            self.playlistView.countLabel.text = count == 0 ? "" : String(count)
        }.store(in: &subscription)
    }

    private func bindPlaylistTableView(output: PlaylistViewModel.Output) {
        output.editState.sink { [weak self] isEditing, reloadStrategy in
            guard let self else { return }
            self.playlistView.titleLabel.text = isEditing ? "재생목록 편집" : "재생목록"
            self.playlistView.editButton.setTitle(isEditing ? "완료" : "편집", for: .normal)
            self.playlistView.editButton.setColor(isHighlight: isEditing)
            self.playlistView.playlistTableView.setEditing(isEditing, animated: true)
            switch reloadStrategy {
            case .reloadAll:
                self.playlistView.playlistTableView.reloadData()
            case .reloadSection:
                self.playlistView.playlistTableView.reloadSections([0], with: .none)
            }
        }.store(in: &subscription)

        output.playlists
            .map { [PlaylistSectionModel.init(model: 0, items: $0)] }
            .do(afterNext: { [currentSongID, tableView = playlistView.playlistTableView] playListSectionModel in
                guard let currentSongID else { return }
                guard
                    let sectionIndex = playListSectionModel.firstIndex(where: { model in
                        model.items.contains(where: { $0.id == currentSongID })
                    }),
                    let itemIndex = playListSectionModel[safe: sectionIndex]?.items
                    .firstIndex(where: { $0.id == currentSongID })
                else { return }
                let index = IndexPath(row: itemIndex, section: sectionIndex)
                DispatchQueue.main.async {
                    tableView.scrollToRow(at: index, at: .middle, animated: false)
                }
            })
            .bind(to: playlistView.playlistTableView.rx.items(dataSource: createDatasources(output: output)))
            .disposed(by: disposeBag)

        output.playlists
            .bind(with: playlistView) { playlistView, playlists in
                if playlists.isEmpty {
                    let space = APP_HEIGHT() - STATUS_BAR_HEGHIT() - 48 - 56 - SAFEAREA_BOTTOM_HEIGHT()
                    let height = space / 3 * 2
                    let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                    warningView.text = "곡이 없습니다."
                    playlistView.playlistTableView.tableFooterView = warningView
                } else {
                    playlistView.playlistTableView.tableFooterView = nil
                }
            }
            .disposed(by: disposeBag)

        output.playlists
            .map { $0.isEmpty }
            .bind(to: playlistView.editButton.rx.isHidden)
            .disposed(by: disposeBag)

        playlistView.playlistTableView.rx.itemSelected
            .withLatestFrom(output.playlists) { ($0, $1) }
            .bind(with: self) { [
                songDetailPresenter,
                isEditingSubject = output.editState,
                tappedCellIndex
            ] owner, item in

                let (isEditing, _) = isEditingSubject.value
                let (indexPath, playlists) = item

                if isEditing {
                    tappedCellIndex.onNext(indexPath.row)
                } else {
                    guard let selectedSong = playlists[safe: indexPath.row] else { return }

                    let currentSongs = playlists
                        .map(\.id)

                    owner.dismiss(animated: true) {
                        songDetailPresenter.present(
                            ids: Array(currentSongs),
                            selectedID: selectedSong.id
                        )
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindSongCart(output: PlaylistViewModel.Output) {
        output.selectedSongIds
            .skip(1)
            .withLatestFrom(output.playlists) { ($0, $1) }
            .map { songs, dataSource -> (songs: Set<String>, dataSourceCount: Int) in
                return (songs, dataSource.count)
            }
            .subscribe(onNext: { [weak self] songs, dataSourceCount in
                guard let self = self else { return }
                self.playlistView.playlistTableView.reloadData()
                self.playlistView.willShowSongCart(isShow: !songs.isEmpty)
                switch songs.isEmpty {
                case true:
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .playlist,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSourceCount,
                        useBottomSpace: true
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
    }

    private func bindCloseButton(output: PlaylistViewModel.Output) {
        output.shouldClosePlaylist.sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
    }
}

extension PlaylistViewController {
    private func createDatasources(
        output: PlaylistViewModel
            .Output
    ) -> RxTableViewSectionedReloadDataSource<PlaylistSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlaylistSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self else { return UITableViewCell() }
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaylistTableViewCell.identifier,
                    for: IndexPath(row: indexPath.row, section: 0)
                ) as? PlaylistTableViewCell
                else { return UITableViewCell() }

                cell.delegate = self
                cell.selectionStyle = .none

                let index = indexPath.row
                let (isEditing, _) = output.editState.value

                cell.setContent(
                    model: model,
                    index: index,
                    isEditing: isEditing,
                    isSelected: output.selectedSongIds.value.contains(model.id)
                )
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
