import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

public final class ChartContentViewController: BaseViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIncidator: NVActivityIndicatorView!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    private let refreshControl = UIRefreshControl()

    private var viewModel: ChartContentViewModel!
    private lazy var input = ChartContentViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    private var containSongsFactory: ContainSongsFactory!

    deinit { LogManager.printDebug("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        inputBind()
        outputBind()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        input.allSongSelected.onNext(false)
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

private extension ChartContentViewController {
    func inputBind() {
        tableView.register(ChartContentTableViewCell.self, forCellReuseIdentifier: "\(ChartContentTableViewCell.self)")
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(to: input.songTapped)
            .disposed(by: disposeBag)

        refreshControl.rx
            .controlEvent(.valueChanged)
            .bind(to: input.refreshPulled)
            .disposed(by: disposeBag)
    }

    func outputBind() {
        output.dataSource
            .skip(1)
            .do(onNext: { [weak self] model in
                guard let self = self else { return }
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
                    withIdentifier: "\(ChartContentTableViewCell.self)",
                    for: indexPath
                ) as? ChartContentTableViewCell else {
                    return UITableViewCell()
                }
                cell.update(model: model, index: index, type: self.viewModel.type)
                return cell
            }
            .disposed(by: disposeBag)

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
            })
            .disposed(by: disposeBag)

        output.songEntityOfSelectedSongs
            .filter { !$0.isEmpty }
            .subscribe()
            .disposed(by: disposeBag)

        output.groupPlaySongs
            .bind(with: self, onNext: { owner, source in
                LogManager.printDebug(source.map { $0.title })
                guard !source.isEmpty else {
                    owner.output.showToast.onNext("차트 데이터가 없습니다.")
                    return
                }
                PlayState.shared.loadAndAppendSongsToPlaylist(source)
            })
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(
                    text: message,
                    font: DesignSystemFontFamily.Pretendard.light.font(size: 14),
                    verticalOffset: 56 + 56 + 40
                )
            }
            .disposed(by: disposeBag)
    }

    func configureUI() {
        view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        activityIncidator.type = .circleStrokeSpin
        activityIncidator.color = DesignSystemAsset.PrimaryColor.point.color
        activityIncidator.startAnimating()
        tableView.refreshControl = refreshControl
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
        guard !output.dataSource.value.isEmpty else {
            output.showToast.onNext("차트 데이터가 없습니다.")
            return
        }

        if event == .allPlay {
            let viewController = ChartPlayPopupViewController()
            viewController.delegate = self
            showBottomSheet(content: viewController, size: .fixed(192 + SAFEAREA_BOTTOM_HEIGHT()))

        } else {
            input.shufflePlayTapped.onNext(())
        }
    }
}

extension ChartContentViewController: ChartPlayPopupViewControllerDelegate {
    public func playTapped(type: HalfPlayType) {
        input.halfPlayTapped.onNext(type)
    }
}

extension ChartContentViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        let limit: Int = 50
        let songs = output.songEntityOfSelectedSongs.value

        switch type {
        case let .allSelect(flag):
            input.allSongSelected.onNext(flag)

        case .addSong:
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowContainWarning(songs.count-limit))
                return
            }
            let songIds: [String] = songs.map { $0.id }
            let viewController = containSongsFactory.makeView(songs: songIds)
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true) {
                self.input.allSongSelected.onNext(false)
            }

        case .addPlayList:
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowAddPlaylistWarning(songs.count-limit))
                return
            }
            PlayState.shared.appendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)

        case .play:
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowPlayWarning(songs.count-limit))
                return
            }
            PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)

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
