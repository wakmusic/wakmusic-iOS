import BaseFeature
import BaseFeatureInterface
import Combine
import DesignSystem
import Foundation
import Kingfisher
import RxDataSources
import RxRelay
import RxSwift
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

    internal var containSongsFactory: ContainSongsFactory!

    public var songCartView: BaseFeature.SongCartView!
    public var bottomSheetView: BaseFeature.BottomSheetView!

    private var panGestureRecognizer: UIPanGestureRecognizer!

    init(viewModel: PlaylistViewModel, containSongsFactory: ContainSongsFactory) {
        self.viewModel = viewModel
        self.containSongsFactory = containSongsFactory
        super.init(nibName: nil, bundle: nil)
    }

    deinit {
        DEBUG_LOG("❌ PlaylistVC deinit")
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("PlaylistViewController has not been implemented")
    }

    override public func loadView() {
        super.loadView()
        playlistView = PlaylistView(frame: self.view.frame)
        self.view.addSubview(playlistView)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        playlistView.playlistTableView.rx.setDelegate(self).disposed(by: disposeBag)
        bindGesture()
        bindViewModel()
        bindActions()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Comment: 재생목록 화면이 사라지는 시점에서 DB에 저장된 리스트로 업데이트
        // 편집 완료를 했으면 이미 DB가 업데이트 됐을거고, 아니면 이전 DB데이터로 업데이트
        self.playState.playList.list = self.playState.fetchPlayListFromLocalDB()
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
            // let opacity = 1 - (distanceY / screenHeight)
            // updateOpacity(value: Float(opacity))

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
                        self.updateOpacity(value: 1)
                    }
                )
            }

        default:
            break
        }
    }

    func updateOpacity(value: Float) {
        playlistView.layer.opacity = value
    }
}

private extension PlaylistViewController {
    private func bindGesture() {
        panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(handlePanGesture(_:))
        )
        self.playlistView.titleBarView.addGestureRecognizer(panGestureRecognizer)
    }

    private func bindViewModel() {
        let input = PlaylistViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            closeButtonDidTapEvent: playlistView.closeButton.tapPublisher,
            editButtonDidTapEvent: playlistView.editButton.tapPublisher,
            playlistTableviewCellDidTapEvent: playlistView.playlistTableView.rx.itemSelected.asObservable(),
            playlistTableviewCellDidTapInEditModeEvent: tappedCellIndex.asObservable(),
            selectAllSongsButtonDidTapEvent: isSelectedAllSongs.asObservable(),
            addPlaylistButtonDidTapEvent: tappedAddPlaylist.asObservable(),
            removeSongsButtonDidTapEvent: tappedRemoveSongs.asObservable(),
            itemMovedEvent: playlistView.playlistTableView.rx.itemMoved.asObservable()
        )
        let output = self.viewModel.transform(from: input)

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
        output.editState.sink { [weak self] isEditing in
            guard let self else { return }
            self.playlistView.titleLabel.text = isEditing ? "재생목록 편집" : "재생목록"
            self.playlistView.editButton.setTitle(isEditing ? "완료" : "편집", for: .normal)
            self.playlistView.editButton.setColor(isHighlight: isEditing)
            self.playlistView.playlistTableView.setEditing(isEditing, animated: true)
            self.playlistView.playlistTableView.reloadData()
        }.store(in: &subscription)

        output.dataSource
            .bind(to: playlistView.playlistTableView.rx.items(dataSource: createDatasources(output: output)))
            .disposed(by: disposeBag)

        output.dataSource
            .filter { $0.first?.items.isEmpty ?? true }
            .subscribe { [weak self] _ in
                let space = APP_HEIGHT() - STATUS_BAR_HEGHIT() - 48 - 56 - SAFEAREA_BOTTOM_HEIGHT()
                let height = space / 3 * 2
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: height))
                warningView.text = "곡이 없습니다."
                self?.playlistView.playlistTableView.tableFooterView = warningView
            }.disposed(by: disposeBag)

        output.dataSource
            .map { return $0.first?.items.isEmpty ?? true }
            .bind(to: playlistView.editButton.rx.isHidden)
            .disposed(by: disposeBag)
    }

    private func bindSongCart(output: PlaylistViewModel.Output) {
        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .map { songs, dataSource -> (songs: [Int], dataSourceCount: Int) in
                return (songs, dataSource.first?.items.count ?? 0)
            }
            .subscribe(onNext: { [weak self] songs, dataSourceCount in
                guard let self = self else { return }
                switch songs.isEmpty {
                case true:
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .playList,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSourceCount,
                        useBottomSpace: true
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)
    }

    private func bindCloseButton(output: PlaylistViewModel.Output) {
        output.willClosePlaylist.sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
    }
}

private extension PlaylistViewController {
    private func bindActions() {
        playlistView.thumbnailImageView.isUserInteractionEnabled = true
        playlistView.thumbnailImageView.tapPublisher().sink { [weak self] _ in
            self?.dismiss(animated: true)
        }.store(in: &subscription)
    }
}

extension PlaylistViewController {
    private func createDatasources(
        output: PlaylistViewModel
            .Output
    ) -> RxTableViewSectionedReloadDataSource<PlayListSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlayListSectionModel>(
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
                let isEditing = output.editState.value
                let isPlaying = model.isPlaying

                cell.setContent(
                    song: model.item,
                    index: index,
                    isEditing: isEditing
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
