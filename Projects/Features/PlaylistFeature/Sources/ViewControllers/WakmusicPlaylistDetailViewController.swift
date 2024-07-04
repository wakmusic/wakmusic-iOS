import BaseFeature
import BaseFeatureInterface
import DesignSystem
import LogManager
import PhotosUI
import ReactorKit
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class WakmusicPlaylistDetailViewController: BaseReactorViewController<WakmusicPlaylistDetailReactor>,
    SongCartViewType {
    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let containSongsFactory: any ContainSongsFactory

    private let textPopUpFactory: any TextPopUpFactory

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
        textPopUpFactory: any TextPopUpFactory
    ) {
        self.containSongsFactory = containSongsFactory
        self.textPopUpFactory = textPopUpFactory

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
        LogManager.analytics(PlaylistAnalyticsLog.viewPage(pageName: "wakmusic_playlist_detail"))
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

        reactor.pulse(\.$toastMessage)
            .bind(with: self) { owner, message in

                guard let message = message else {
                    return
                }

                owner.showToast(text: message, font: .setFont(.t6(weight: .light)))
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
                    owner.tableView.setBackgroundView(warningView, APP_HEIGHT() / 2.5)
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
                } else {
                    owner.indicator.stopAnimating()
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
        let playbuttonGroupView = PlayButtonGroupView()
        playbuttonGroupView.delegate = self

        guard let reactor = reactor else {
            return nil
        }

        if reactor.currentState.dataSource.isEmpty {
            return nil
        } else {
            return playbuttonGroupView
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

/// 전체재생 , 랜덤 재생 델리게이트
extension WakmusicPlaylistDetailViewController: PlayButtonGroupViewDelegate {
    func play(_ event: PlayEvent) {
        DEBUG_LOG("playGroup Touched")
        #warning("재생 이벤트 넣기")
        switch event {
        case .allPlay:
            break
        case .shufflePlay:
            break
        }
    }
}

/// 송카트 델리게이트
extension WakmusicPlaylistDetailViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        guard let reactor = reactor else {
            return
        }

        let currentState = reactor.currentState

        switch type {
        case let .allSelect(flag: flag):
            if flag {
                reactor.action.onNext(.selectAll)
            } else {
                reactor.action.onNext(.deselectAll)
            }
        case .addSong:
            let vc = containSongsFactory.makeView(songs: currentState.dataSource.filter { $0.isSelected }.map { $0.id })
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true)
            reactor.action.onNext(.deselectAll)

        case .addPlayList:
            #warning("재생목록 관련 구현체 구현 시 추가")
            reactor.action.onNext(.deselectAll)
            break
        case .play:
            #warning("재생 구현")
            reactor.action.onNext(.deselectAll)
            break
        case .remove:
            break
        }
    }
}
