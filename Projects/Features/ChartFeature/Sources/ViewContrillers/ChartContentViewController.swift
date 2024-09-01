import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SignInFeatureInterface
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
    private var textPopupFactory: TextPopupFactory!
    private var signInFactory: SignInFactory!
    private var songDetailPresenter: SongDetailPresentable!

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
        containSongsFactory: ContainSongsFactory,
        textPopupFactory: TextPopupFactory,
        signInFactory: SignInFactory,
        songDetailPresenter: SongDetailPresentable
    ) -> ChartContentViewController {
        let viewController = ChartContentViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.containSongsFactory = containSongsFactory
        viewController.textPopupFactory = textPopupFactory
        viewController.signInFactory = signInFactory
        viewController.songDetailPresenter = songDetailPresenter
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
                guard let self,
                      let cell = tableView.dequeueReusableCell(
                          withIdentifier: "\(ChartContentTableViewCell.self)",
                          for: IndexPath(row: index, section: 0)
                      ) as? ChartContentTableViewCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
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
                guard !source.songs.isEmpty else {
                    owner.output.showToast.onNext("차트 데이터가 없습니다.")
                    return
                }
                PlayState.shared.loadAndAppendSongsToPlaylist(source.songs)
                if source.songs.allSatisfy({ $0.title.isContainShortsTagTitle }) {
                    WakmusicYoutubePlayer(ids: source.songs.map { $0.id }, title: source.playlistTitle, playPlatform: .youtube).play()
                } else {
                    WakmusicYoutubePlayer(ids: source.songs.map { $0.id }, title: source.playlistTitle).play()
                }
            })
            .disposed(by: disposeBag)

        output.showToast
            .bind(with: self) { owner, message in
                owner.showToast(
                    text: message,
                    options: [.tabBar, .songCart]
                )
            }
            .disposed(by: disposeBag)

        output.showLogin
            .bind(with: self) { owner, _ in
                let viewController = owner.textPopupFactory.makeView(
                    text: "로그인이 필요한 서비스입니다.\n로그인 하시겠습니까?",
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let log = CommonAnalyticsLog.clickLoginButton(entry: .addMusics)
                        LogManager.analytics(log)

                        let loginVC = owner.signInFactory.makeView()
                        loginVC.modalPresentationStyle = .overFullScreen
                        owner.present(loginVC, animated: true)
                    },
                    cancelCompletion: {}
                )
                owner.showBottomSheet(content: viewController)
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

extension ChartContentViewController: ChartContentTableViewCellDelegate {
    func tappedThumbnail(id: String) {
        guard let tappedSong = output.dataSource.value
            .first(where: { $0.id == id })
        else { return }
        PlayState.shared.append(item: .init(id: tappedSong.id, title: tappedSong.title, artist: tappedSong.artist))
        let playlistIDs = PlayState.shared.currentPlaylist
            .map(\.id)
        songDetailPresenter.present(ids: playlistIDs, selectedID: tappedSong.id)
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
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .chart, type: .all)
            )
            let viewController = ChartPlayPopupViewController()
            viewController.delegate = self
            showBottomSheet(content: viewController, size: .fixed(192 + SAFEAREA_BOTTOM_HEIGHT()))

        } else {
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .chart, type: .random)
            )
            input.shufflePlayTapped.onNext(())
        }
    }
}

extension ChartContentViewController: ChartPlayPopupViewControllerDelegate {
    public func playTapped(type: HalfPlayType) {
        switch type {
        case .front: // 1-50
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .chart, type: .range1to50)
            )
        case .back: // 50-100
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .chart, type: .range50to100)
            )
        }
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
            let log = CommonAnalyticsLog.clickAddMusicsButton(location: .chart)
            LogManager.analytics(log)
            if PreferenceManager.userInfo == nil {
                output.showLogin.onNext(())
                return
            }

            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowContainWarning(songs.count - limit))
                return
            }

            let songIds: [String] = songs.map { $0.id }
            let viewController = containSongsFactory.makeView(songs: songIds)
            viewController.modalPresentationStyle = .overFullScreen
            present(viewController, animated: true) {
                self.input.allSongSelected.onNext(false)
            }

        case .addPlayList:
            PlayState.shared.appendSongsToPlaylist(songs)
            output.showToast.onNext(LocalizationStrings.addList)
            input.allSongSelected.onNext(false)

        case .play:
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowPlayWarning(songs.count - limit))
                return
            }
            PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .chart, type: .multiple)
            )
            if songs.allSatisfy({ $0.title.isContainShortsTagTitle }) {
                WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직", playPlatform: .youtube).play()
            } else {
                WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직").play()
            }

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
