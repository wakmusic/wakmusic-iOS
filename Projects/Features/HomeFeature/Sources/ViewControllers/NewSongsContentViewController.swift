import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import NVActivityIndicatorView
import RxCocoa
import RxSwift
import SignInFeatureInterface
import SongsDomainInterface
import UIKit
import Utility

public class NewSongsContentViewController: UIViewController, ViewControllerFromStoryBoard, SongCartViewType {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIncidator: NVActivityIndicatorView!

    private var viewModel: NewSongsContentViewModel!
    fileprivate lazy var input = NewSongsContentViewModel.Input()
    fileprivate lazy var output = viewModel.transform(from: input)
    private let disposeBag = DisposeBag()

    private var containSongsFactory: ContainSongsFactory!
    private var textPopupFactory: TextPopupFactory!
    private var signInFactory: SignInFactory!
    private var songDetailPresenter: SongDetailPresentable!

    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!
    private var refreshControl = UIRefreshControl()

    deinit { DEBUG_LOG("❌ \(Self.self) Deinit") }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.input.allSongSelected.onNext(false)
    }

    public static func viewController(
        viewModel: NewSongsContentViewModel,
        containSongsFactory: ContainSongsFactory,
        textPopupFactory: TextPopupFactory,
        signInFactory: SignInFactory,
        songDetailPresenter: SongDetailPresentable
    ) -> NewSongsContentViewController {
        let viewController = NewSongsContentViewController.viewController(
            storyBoardName: "Home",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        viewController.containSongsFactory = containSongsFactory
        viewController.textPopupFactory = textPopupFactory
        viewController.signInFactory = signInFactory
        viewController.songDetailPresenter = songDetailPresenter
        return viewController
    }
}

private extension NewSongsContentViewController {
    func inputBind() {
        input.fetchPlaylistURL.onNext(())

        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)

        tableView.rx.willDisplayCell
            .map { $1 }
            .withLatestFrom(
                output.dataSource,
                resultSelector: { indexPath, datasource -> (IndexPath, [NewSongsEntity]) in
                    return (indexPath, datasource)
                }
            )
            .filter { indexPath, datasources -> Bool in
                return indexPath.item == datasources.count - 1
            }
            .withLatestFrom(output.canLoadMore)
            .filter { $0 }
            .map { _ in return () }
            .bind(to: rx.loadMore)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .map { $0.row }
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
            .withLatestFrom(output.indexOfSelectedSongs) { ($0, $1) }
            .do(onNext: { [weak self] dataSource, songs in
                guard let self = self else { return }
                self.activityIncidator.stopAnimating()
                self.refreshControl.endRefreshing()
                let space: CGFloat = APP_HEIGHT() - 48 - 40 - 56 - 56 - STATUS_BAR_HEGHIT() - SAFEAREA_BOTTOM_HEIGHT()
                let height: CGFloat = space / 3 * 2
                let warningView: WarningView = WarningView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: height
                ))
                warningView.text = "데이터가 없습니다."
                self.tableView.tableFooterView = dataSource.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: PLAYER_HEIGHT()
                ))
                if let songCart = self.songCartView {
                    songCart.updateAllSelect(isAll: songs.count == dataSource.count)
                }
            })
            .map { $0.0 }
            .bind(to: tableView.rx.items) { [weak self] tableView, index, model -> UITableViewCell in
                guard let self = self,
                      let cell = tableView.dequeueReusableCell(
                          withIdentifier: "NewSongsCell",
                          for: IndexPath(row: index, section: 0)
                      ) as? NewSongsCell else {
                    return UITableViewCell()
                }
                cell.delegate = self
                cell.update(model: model)
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

        output.playlistURL
            .subscribe()
            .disposed(by: disposeBag)

        output.showToast
            .withLatestFrom(output.songEntityOfSelectedSongs) { ($0, $1) }
            .bind(with: self) { owner, model in
                let (message, selectedSongs) = model
                owner.showToast(
                    text: message,
                    options: selectedSongs.isEmpty ? [.tabBar] : [.tabBar, .songCart]
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
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        tableView.sectionHeaderTopPadding = 0
    }
}

extension NewSongsContentViewController: NewSongsCellDelegate {
    func tappedThumbnail(id: String) {
        guard let tappedSong = output.dataSource.value
            .first(where: { $0.id == id })
        else { return }
        PlayState.shared.append(item: .init(id: tappedSong.id, title: tappedSong.title, artist: tappedSong.artist))
        let playlistIDs = PlayState.shared.currentPlaylist
            .map(\.id)
        songDetailPresenter.present(ids: playlistIDs, selectedID: id)
    }
}

extension NewSongsContentViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 78
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SingleActionButtonView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 78))
        view.delegate = self
        view.setTitleAndImage(text: "전체재생", image: DesignSystemAsset.Chart.allPlay.image)
        return view
    }
}

extension NewSongsContentViewController: SingleActionButtonViewDelegate {
    public func tappedButtonAction() {
        let playlistURL: String = output.playlistURL.value
        guard !playlistURL.isEmpty, let url = URL(string: playlistURL) else {
            output.showToast.onNext("해당 기능은 준비 중입니다.")
            return
        }
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let listID = components.queryItems?.first(where: { $0.name == "list" })?.value {
            WakmusicYoutubePlayer(listID: listID).play()
        }

        let songs: [SongEntity] = output.dataSource.value.map {
            return SongEntity(
                id: $0.id,
                title: $0.title,
                artist: $0.artist,
                views: $0.views,
                date: "\($0.date)"
            )
        }
        LogManager.analytics(
            CommonAnalyticsLog.clickPlayButton(location: .recentMusic, type: .all)
        )
        PlayState.shared.loadAndAppendSongsToPlaylist(songs)
    }
}

extension NewSongsContentViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        let limit: Int = 50
        let songs: [SongEntity] = output.songEntityOfSelectedSongs.value

        switch type {
        case let .allSelect(flag):
            input.allSongSelected.onNext(flag)

        case .addSong:
            let log = CommonAnalyticsLog.clickAddMusicsButton(location: .recentMusic)
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
            self.present(viewController, animated: true) {
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
                CommonAnalyticsLog.clickPlayButton(location: .recentMusic, type: .multiple)
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

extension Reactive where Base: NewSongsContentViewController {
    var loadMore: Binder<Void> {
        return Binder(base) { viewController, _ in
            let pageID = viewController.input.pageID.value
            viewController.input.pageID.accept(pageID + 1)
        }
    }
}
