import BaseFeature
import BaseFeatureInterface
import DesignSystem
import ReactorKit
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

#warning("송카트, 공유하기, 이미지 업로드")

final class MyPlaylistDetailViewController: BaseReactorViewController<MyPlaylistDetailReactor>,
    PlaylistEditSheetViewType, PlaylistImageEditSheetViewType,
    SongCartViewType {
    var playlistImageEditSheetView: PlaylistImageEditSheetView!

    var playlisteditSheetView: PlaylistEditSheetView!

    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let multiPurposePopupFactory: any MultiPurposePopupFactory

    private let containSongsFactory: any ContainSongsFactory

    private let textPopUpFactory: any TextPopUpFactory

    private var wmNavigationbarView: WMNavigationBarView = WMNavigationBarView()

    private var lockButton: UIButton = UIButton()
    private let lockImage = DesignSystemAsset.Playlist.lock.image
    private let unLockImage = DesignSystemAsset.Playlist.unLock.image

    fileprivate let dismissButton = UIButton().then {
        let dismissImage = DesignSystemAsset.Navigation.back.image
            .withTintColor(DesignSystemAsset.BlueGrayColor.blueGray900.color, renderingMode: .alwaysOriginal)
        $0.setImage(dismissImage, for: .normal)
    }

    private var moreButton: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.MyInfo.more.image, for: .normal)
    }

    private var headerView: MyPlaylistHeaderView = MyPlaylistHeaderView(frame: .init(
        x: .zero,
        y: .zero,
        width: APP_WIDTH(),
        height: 140
    ))

    private lazy var tableView: UITableView = UITableView().then {
        $0.backgroundColor = .clear
        $0.register(PlaylistTableViewCell.self, forCellReuseIdentifier: PlaylistTableViewCell.identifier)
        $0.tableHeaderView = headerView
        $0.separatorStyle = .none
        $0.contentInset = .init(top: .zero, left: .zero, bottom: 60.0, right: .zero)
    }

    private lazy var completeButton: RectangleButton = RectangleButton().then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: true)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }

    lazy var dataSource: MyplaylistDetailDataSource = createDataSource()

    init(
        reactor: MyPlaylistDetailReactor,
        multiPurposePopupFactory: any MultiPurposePopupFactory,
        containSongsFactory: any ContainSongsFactory,
        textPopUpFactory: any TextPopUpFactory
    ) {
        self.multiPurposePopupFactory = multiPurposePopupFactory
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
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        hideplaylistEditSheet()
        hideSongCart()
        hideplaylistImageEditSheet()
        reactor?.action.onNext(.deselectAll)
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, tableView)
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setRightViews([lockButton, moreButton, completeButton])
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

        completeButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
            $0.bottom.equalToSuperview().offset(-5)
        }
    }

    override func configureUI() {
        super.configureUI()
    }

    override func bind(reactor: MyPlaylistDetailReactor) {
        super.bind(reactor: reactor)
        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }

    override func bindAction(reactor: MyPlaylistDetailReactor) {
        super.bindAction(reactor: reactor)

        let sharedState = reactor.state.share()

        lockButton.rx
            .tap
            .asDriver()
            .throttle(.seconds(1))
            .drive(onNext: {
                reactor.action.onNext(.privateButtonDidTap)

            })
            .disposed(by: disposeBag)

        dismissButton.rx
            .tap
            .withLatestFrom(sharedState.map(\.isEditing))
            .bind(with: self) { owner, isEditing in

                let vc = owner.textPopUpFactory.makeView(
                    text: "변경된 내용을 저장할까요",
                    cancelButtonIsHidden: false,
                    confirmButtonText: "확인",
                    cancelButtonText: "취소"
                ) {
                    reactor.action.onNext(.forceSave)
                    owner.navigationController?.popViewController(animated: true)

                } cancelCompletion: {
                    reactor.action.onNext(.restore)
                    owner.navigationController?.popViewController(animated: true)
                }

                if isEditing {
                    owner.showBottomSheet(content: vc)
                } else {
                    owner.navigationController?.popViewController(animated: true)
                }
            }
            .disposed(by: disposeBag)

        moreButton.rx
            .tap
            .bind(with: self) { owner, _ in
                owner.showplaylistEditSheet(in: owner.view)
                owner.playlisteditSheetView?.delegate = owner
            }
            .disposed(by: disposeBag)

        completeButton.rx
            .tap
            .map { Reactor.Action.completeButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        headerView.rx.editNickNameButtonDidTap
            .bind(with: self) { owner, _ in

                guard let reactor = owner.reactor else {
                    return
                }

                let vc = owner.multiPurposePopupFactory.makeView(type: .updatePlaylistTitle, key: reactor.key) { text in
                    reactor.action.onNext(.changeTitle(text))
                }

                owner.showBottomSheet(content: vc, size: .fixed(296))

                DEBUG_LOG("탭 이름 변경 버튼")
            }
            .disposed(by: disposeBag)

        headerView.rx.cameraButtonDidTap
            .bind(with: self) { owner, _ in
                DEBUG_LOG("카메라 버튼 탭")
                owner.hideplaylistEditSheet()

                owner.showplaylistImageEditSheet(in: owner.view)
                owner.playlistImageEditSheetView.delegate = owner
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: MyPlaylistDetailReactor) {
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

        sharedState.map(\.isEditing)
            .distinctUntilChanged()
            .bind(with: self) { owner, isEditing in
                owner.lockButton.isHidden = isEditing
                owner.moreButton.isHidden = isEditing
                owner.completeButton.isHidden = !isEditing
                owner.tableView.isEditing = isEditing
                owner.headerView.updateEditState(isEditing)
                owner.navigationController?.interactivePopGestureRecognizer?.delegate = isEditing ? owner : nil
                owner.tableView.reloadData()
            }
            .disposed(by: disposeBag)

        sharedState.map(\.header)
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, model in
                owner.headerView.updateData(model)
                owner.lockButton.setImage(model.private ? owner.lockImage : owner.unLockImage, for: .normal)
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
                        type: .myPlaylist,
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

extension MyPlaylistDetailViewController {
    func createDataSource() -> MyplaylistDetailDataSource {
        #warning("옵셔널 해결하기")

        let dataSource =
            MyplaylistDetailDataSource(
                reactor: reactor!,
                tableView: tableView
            ) { [weak self] tableView, indexPath, itemIdentifier in

                guard let self, let cell = tableView.dequeueReusableCell(
                    withIdentifier: PlaylistTableViewCell.identifier,
                    for: indexPath
                ) as? PlaylistTableViewCell else {
                    return UITableViewCell()
                }

                cell.delegate = self
                cell.setContent(song: itemIdentifier, index: indexPath.row, isEditing: tableView.isEditing)
                cell.selectionStyle = .none

                return cell
            }

        tableView.dataSource = dataSource

        return dataSource
    }
}

extension MyPlaylistDetailViewController: UITableViewDelegate {
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

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DEBUG_LOG("HELLo")
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        DEBUG_LOG("\(sourceIndexPath) \(destinationIndexPath)")
    }
}

extension MyPlaylistDetailViewController: PlayButtonGroupViewDelegate {
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

extension MyPlaylistDetailViewController: PlaylistTableViewCellDelegate {
    func superButtonTapped(index: Int) {
        tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: false)
        reactor?.action.onNext(.itemDidTap(index))
    }
}

extension MyPlaylistDetailViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

extension MyPlaylistDetailViewController: SongCartViewDelegate {
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
            let vc = containSongsFactory.makeView(songs: currentState.dataSource.map { $0.id })
            vc.modalPresentationStyle = .fullScreen

            self.present(vc, animated: true)

            break
        case .addPlayList:
            #warning("재생목록 관련 구현체 구현 시 추가")
            break
        case .play:
            break
        case .remove:
            break
        }
    }
}

extension MyPlaylistDetailViewController: PlaylistEditSheetDelegate {
    func didTap(_ type: PlaylistEditType) {
        switch type {
        case .edit:
            reactor?.action.onNext(.editButtonDidTap)
        case .share:
            #warning("공유 작업")
            break
        }

        self.hideplaylistEditSheet()
    }
}

extension MyPlaylistDetailViewController: PlaylistImageEditSheetDelegate {
    func didTap(_ type: PlaylistImageEditType) {
        DEBUG_LOG(type) // 탭
        switch type {
        case .gallery:
            #warning("갤러리")
            break
        case .default:
            #warning("기본 팝업")
            break
        }

        self.hideplaylistImageEditSheet()
    }
}
