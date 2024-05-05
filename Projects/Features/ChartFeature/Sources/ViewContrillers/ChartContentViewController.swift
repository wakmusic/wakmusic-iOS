import BaseFeature
import BaseFeatureInterface
import DesignSystem
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

public class ChartContentViewController: BaseViewController, ViewControllerFromStoryBoard, SongCartViewType {
    private let disposeBag = DisposeBag()
    private var viewModel: ChartContentViewModel!

    fileprivate lazy var input = ChartContentViewModel.Input()
    fileprivate lazy var output = viewModel.transform(from: input)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIncidator: NVActivityIndicatorView!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    private var refreshControl = UIRefreshControl()

    let playState = PlayState.shared

    private var containSongsFactory: ContainSongsFactory!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        outputBind()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.input.allSongSelected.onNext(false)
    }

    public static func viewController(
        viewModel: ChartContentViewModel,
        containSongsFactory: ContainSongsFactory
    ) -> ChartContentViewController {
        let viewController = ChartContentViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.containSongsFactory = containSongsFactory
        return viewController
    }
}

extension ChartContentViewController {
    private func bind() {
        tableView.register(ChartContentTableViewCell.self, forCellReuseIdentifier: "chartContentTableViewCell")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { $0.row }
            .bind(to: input.songTapped)
            .disposed(by: disposeBag)

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: input.refreshPulled)
            .disposed(by: disposeBag)
    }

    private func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let `self` = self else { return }
                self.activityIncidator.stopAnimating()
                self.refreshControl.endRefreshing()
                let space: CGFloat = APP_HEIGHT() - 40 - 102 - 56 - 56 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
                let height: CGFloat = space / 3 * 2
                let warningView: WarningView = WarningView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: height
                ))
                warningView.text = "차트 데이터가 없습니다."
                self.tableView.tableFooterView = model.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: PLAYER_HEIGHT()
                ))
            })
            .bind(to: tableView.rx.items) { [weak self] tableView, index, model -> UITableViewCell in
                guard let self else { return UITableViewCell() }
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "chartContentTableViewCell",
                    for: indexPath
                ) as? ChartContentTableViewCell else {
                    return UITableViewCell()
                }
                cell.update(model: model, index: index, type: self.viewModel.type)
                return cell
            }.disposed(by: disposeBag)

        output.indexOfSelectedSongs
            .skip(1)
            .withLatestFrom(output.dataSource) { ($0, $1) }
            .subscribe(onNext: { [weak self] songs, dataSource in
                guard let self = self else { return }
                switch songs.isEmpty {
                case true:
                    self.hideSongCart()
                case false:
                    self.showSongCart(
                        in: self.view,
                        type: .chartSong,
                        selectedSongCount: songs.count,
                        totalSongCount: dataSource.count,
                        useBottomSpace: false
                    )
                    self.songCartView?.delegate = self
                }
            }).disposed(by: disposeBag)

        output.songEntityOfSelectedSongs
            .filter { !$0.isEmpty }
            .subscribe()
            .disposed(by: disposeBag)

        output.groupPlaySongs
            .subscribe(onNext: { [weak self] songs in
                guard let self = self else { return }
                self.playState.loadAndAppendSongsToPlaylist(songs)
            })
            .disposed(by: disposeBag)
    }

    private func configureUI() {
        view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        self.activityIncidator.type = .circleStrokeSpin
        self.activityIncidator.color = DesignSystemAsset.PrimaryColor.point.color
        self.activityIncidator.startAnimating()
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: PLAYER_HEIGHT()))
        self.tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: PLAYER_HEIGHT(), right: 0)
        self.tableView.refreshControl = refreshControl
    }
}

extension ChartContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 102
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PlayButtonForChartView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 102))
        view.setUpdateTime(updateTime: output.updateTime)
        view.delegate = self
        return view
    }
}

extension ChartContentViewController: PlayButtonForChartViewDelegate {
    public func pressPlay(_ event: PlayEvent) {
        input.groupPlayTapped.onNext(event)
    }
}

extension ChartContentViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        switch type {
        case let .allSelect(flag):
            input.allSongSelected.onNext(flag)

        case .addSong:
            let songs: [String] = output.songEntityOfSelectedSongs.value.map { $0.id }
            let viewController = containSongsFactory.makeView(songs: songs)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true) {
                self.input.allSongSelected.onNext(false)
            }
        case .addPlayList:
            let songs = output.songEntityOfSelectedSongs.value
            playState.appendSongsToPlaylist(songs)
            self.input.allSongSelected.onNext(false)

        case .play:
            let songs = output.songEntityOfSelectedSongs.value
            playState.loadAndAppendSongsToPlaylist(songs)
            self.input.allSongSelected.onNext(false)

        case .remove:
            return
        }
    }
}

public extension ChartContentViewController {
    func scrollToTop() {
        guard !output.dataSource.value.isEmpty else { return }
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
}
