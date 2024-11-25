import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import PhotosUI
import ReactorKit
import SignInFeatureInterface
import SnapKit
@preconcurrency import SongsDomainInterface
import Then
import UIKit
import Utility

final class WakmusicPlaylistDetailViewController: BaseReactorViewController<WakmusicPlaylistDetailReactor>,
    @preconcurrency SongCartViewType {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let containSongsFactory: any ContainSongsFactory

    private let textPopupFactory: any TextPopupFactory

    private let songDetailPresenter: any SongDetailPresentable

    private let signInFactory: any SignInFactory

    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private var headerView: WakmusicPlaylistHeaderView = WakmusicPlaylistHeaderView(frame: .init(
        x: .zero,
        y: .zero,
        width: APP_WIDTH(),
        height: 140
    ))

    private lazy var tableView: UITableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(PlaylistDateTableViewCell.self, forCellReuseIdentifier: PlaylistDateTableViewCell.identifier)
        $0.tableHeaderView = headerView
        $0.separatorStyle = .none
        $0.contentInset = .init(top: .zero, left: .zero, bottom: 60.0, right: .zero)
    }

    lazy var dataSource: UnknownPlaylistDetailDataSource = createDataSource()

    init(
        reactor: WakmusicPlaylistDetailReactor,
        containSongsFactory: any ContainSongsFactory,
        textPopupFactory: any TextPopupFactory,
        songDetailPresenter: any SongDetailPresentable,
        signInFactory: any SignInFactory
    ) {
        self.containSongsFactory = containSongsFactory
        self.textPopupFactory = textPopupFactory
        self.songDetailPresenter = songDetailPresenter
        self.signInFactory = signInFactory

        super.init(reactor: reactor)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        LogManager
            .analytics(CommonAnalyticsLog.viewPage(pageName: .wakmusicPlaylistDetail))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        hideAll()
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, tableView)
        wmNavigationbarView.setLeftViews([dismissButton])
    }

    override func setLayout() {
        super.setLayout()

        wmNavigationbarView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(48)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(wmNavigationbarView.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    override func bind(reactor: WakmusicPlaylistDetailReactor) {
        super.bind(reactor: reactor)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: WakmusicPlaylistDetailReactor) {
        super.bindAction(reactor: reactor)

        let sharedState = reactor.state.share()

        dismissButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: WakmusicPlaylistDetailReactor) {
        super.bindState(reactor: reactor)

        let sharedState = reactor.state.share()

        let currentState = reactor.currentState

        reactor.pulse(\.$toastMessage)
            .bind(with: self) { owner, message in

                guard let message = message else {
                    return
                }

                owner.showToast(
                    text: message,
                    options: currentState.selectedCount == .zero ? [.tabBar] : [.tabBar, .songCart]
                )
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$showLoginPopup)
            .filter { $0 }
            .bind(with: self) { owner, _ in
                let vc = TextPopupViewController.viewController(
                    text: LocalizationStrings.needLoginWarning,
                    cancelButtonIsHidden: false,
                    completion: { () in
                        let vc = owner.signInFactory.makeView()
                        vc.modalPresentationStyle = .fullScreen
                        owner.present(vc, animated: true)
                    }
                )

                owner.showBottomSheet(content: vc)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.header)
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, model in
                owner.headerView.updateData(model)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.dataSource)
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, model in
                var snapShot = NSDiffableDataSourceSnapshot<Int, SongEntity>()

                let warningView = WMWarningView(
                    text: "리스트에 곡이 없습니다."
                )

                if model.isEmpty {
                    owner.tableView.setBackgroundView(warningView, APP_HEIGHT() / 3)
                } else {
                    owner.tableView.restore()
                }
                snapShot.appendSections([0])
                snapShot.appendItems(model)

                owner.dataSource.apply(snapShot, animatingDifferences: false)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.isLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoading in

                if isLoading {
                    owner.indicator.startAnimating()
                    owner.tableView.isHidden = true
                } else {
                    owner.indicator.stopAnimating()
                    owner.tableView.isHidden = false
                }
            }
            .disposed(by: disposeBag)

        sharedState.map(\.selectedCount)
            .distinctUntilChanged()
            .withLatestFrom(sharedState.map(\.header)) { ($0, $1) }
            .bind(with: self) { owner, info in

                let (count, limit) = (info.0, info.1.songCount)

                if count == .zero {
                    owner.hideSongCart()
                } else {
                    owner.showSongCart(
                        in: owner.view,
                        type: .WMPlaylist,
                        selectedSongCount: count,
                        totalSongCount: limit,
                        useBottomSpace: false
                    )
                    owner.songCartView.delegate = owner
                }
            }
            .disposed(by: disposeBag)
    }
}

extension WakmusicPlaylistDetailViewController {
    func createDataSource() -> UnknownPlaylistDetailDataSource {
        let dataSource =
            UnknownPlaylistDetailDataSource(
                tableView: tableView
            ) { [weak self] tableView, indexPath, itemIdentifier in

                guard let self, let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaylistDateTableViewCell.identifier,
                    for: indexPath
                ) as? PlaylistDateTableViewCell else {
                    return UITableViewCell()
                }

                cell.delegate = self
                cell.update(itemIdentifier)
                cell.selectionStyle = .none

                return cell
            }

        tableView.dataSource = dataSource

        return dataSource
    }

    func hideAll() {
        hideSongCart()
        reactor?.action.onNext(.deselectAll)
    }
}

/// 테이블 뷰 델리게이트
extension WakmusicPlaylistDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60.0)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SingleActionButtonView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 78))
        view.delegate = self
        view.setTitleAndImage(text: "전체재생", image: DesignSystemAsset.Chart.allPlay.image)

        guard let reactor = reactor else {
            return nil
        }

        if reactor.currentState.dataSource.isEmpty {
            return nil
        } else {
            return view
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let reactor = reactor else {
            return .zero
        }

        if reactor.currentState.dataSource.isEmpty {
            return .zero
        } else {
            return CGFloat(52.0 + 32.0)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        reactor?.action.onNext(.itemDidTap(indexPath.row))
    }
}

extension WakmusicPlaylistDetailViewController: SingleActionButtonViewDelegate {
    func tappedButtonAction() {
        guard let currentState = self.reactor?.currentState, let playlistURL = currentState.playlistURL,
              let url = URL(string: playlistURL) else {
            showToast(text: "해당 기능은 준비 중입니다.", options: [.tabBar])
            return
        }

        let songs = currentState.dataSource

        LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistPlayButton(type: "all", key: reactor?.key ?? ""))
        PlayState.shared.append(contentsOf: songs.map { PlaylistItem(item: $0) })
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let listID = components.queryItems?.first(where: { $0.name == "list" })?.value {
            WakmusicYoutubePlayer(listID: listID).play()
        }
    }
}

extension WakmusicPlaylistDetailViewController: PlaylistDateTableViewCellDelegate {
    func thumbnailDidTap(key: String) {
        guard let tappedSong = reactor?.currentState.dataSource
            .first(where: { $0.id == key })
        else { return }
        PlayState.shared.append(item: .init(id: tappedSong.id, title: tappedSong.title, artist: tappedSong.artist))
        let playlistIDs = PlayState.shared.currentPlaylist
            .map(\.id)
        songDetailPresenter.present(ids: playlistIDs, selectedID: key)
    }
}

/// 송카트 델리게이트
extension WakmusicPlaylistDetailViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        guard let reactor = reactor else {
            return
        }

        let currentState = reactor.currentState
        let songs = currentState.dataSource.filter { $0.isSelected }
        let limit = 50

        switch type {
        case let .allSelect(flag: flag):
            if flag {
                reactor.action.onNext(.selectAll)
            } else {
                reactor.action.onNext(.deselectAll)
            }
        case .addSong:
            let log = CommonAnalyticsLog.clickAddMusicsButton(location: .playlistDetail)
            LogManager.analytics(log)

            guard songs.count <= limit else {
                showToast(
                    text: LocalizationStrings.overFlowContainWarning(songs.count - limit),
                    options: [.tabBar, .songCart]
                )
                return
            }

            if PreferenceManager.shared.userInfo == nil {
                reactor.action.onNext(.requestLoginRequiredAction)
                return
            }

            let vc = containSongsFactory.makeView(songs: songs.map { $0.id })
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            reactor.action.onNext(.deselectAll)

        case .addPlayList:

            PlayState.shared.append(contentsOf: songs.map { PlaylistItem(item: $0) })
            reactor.action.onNext(.deselectAll)
            showToast(
                text: Localization.LocalizationStrings.addList,
                options: [.tabBar]
            )

        case .play:

            guard songs.count <= limit else {
                showToast(
                    text: LocalizationStrings.overFlowPlayWarning(songs.count - limit),
                    options: [.tabBar, .songCart]
                )
                return
            }
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .playlistDetail, type: .multiple)
            )
            PlayState.shared.append(contentsOf: songs.map { PlaylistItem(item: $0) })
            if songs.allSatisfy({ $0.title.isContainShortsTagTitle }) {
                WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직", playPlatform: .youtube).play()
            } else {
                WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직").play()
            }
            reactor.action.onNext(.deselectAll)

        case .remove:
            break
        }
    }
}
