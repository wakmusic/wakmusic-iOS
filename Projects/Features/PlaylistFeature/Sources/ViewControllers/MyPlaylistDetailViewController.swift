import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import NVActivityIndicatorView
import PhotosUI
import PlaylistFeatureInterface
import ReactorKit
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

final class MyPlaylistDetailViewController: BaseReactorViewController<MyPlaylistDetailReactor>,
    PlaylistEditSheetViewType, SongCartViewType {
    private enum Limit {
        static let imageSizeLimitPerMB: Double = 10.0
    }

    var playlisteditSheetView: PlaylistEditSheetView!

    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    private let multiPurposePopupFactory: any MultiPurposePopupFactory

    private let containSongsFactory: any ContainSongsFactory

    private let textPopupFactory: any TextPopupFactory

    private let playlistCoverOptionPopupFactory: any PlaylistCoverOptionPopupFactory

    private let checkPlaylistCoverFactory: any CheckPlaylistCoverFactory

    private let defaultPlaylistCoverFactory: any DefaultPlaylistCoverFactory

    private let songDetailPresenter: any SongDetailPresentable

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
        $0.isHidden = true
    }

    private var saveCompletionIndicator = NVActivityIndicatorView(frame: .zero).then {
        $0.color = DesignSystemAsset.PrimaryColorV2.point.color
        $0.type = .circleStrokeSpin
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

    private lazy var completionButton: RectangleButton = RectangleButton().then {
        $0.setBackgroundColor(.clear, for: .normal)
        $0.setColor(isHighlight: true)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .init(font: DesignSystemFontFamily.Pretendard.bold, size: 12)
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 4
    }

    lazy var dataSource: MyPlaylistDetailDataSource = createDataSource()

    init(
        reactor: MyPlaylistDetailReactor,
        multiPurposePopupFactory: any MultiPurposePopupFactory,
        containSongsFactory: any ContainSongsFactory,
        textPopupFactory: any TextPopupFactory,
        playlistCoverOptionPopupFactory: any PlaylistCoverOptionPopupFactory,
        checkPlaylistCoverFactory: any CheckPlaylistCoverFactory,
        defaultPlaylistCoverFactory: any DefaultPlaylistCoverFactory,
        songDetailPresenter: any SongDetailPresentable
    ) {
        self.multiPurposePopupFactory = multiPurposePopupFactory
        self.containSongsFactory = containSongsFactory
        self.textPopupFactory = textPopupFactory
        self.playlistCoverOptionPopupFactory = playlistCoverOptionPopupFactory
        self.checkPlaylistCoverFactory = checkPlaylistCoverFactory
        self.defaultPlaylistCoverFactory = defaultPlaylistCoverFactory
        self.songDetailPresenter = songDetailPresenter

        super.init(reactor: reactor)
    }

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .myPlaylistDetail))
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        hideAll()
    }

    override func addView() {
        super.addView()
        self.view.addSubviews(wmNavigationbarView, tableView, saveCompletionIndicator)
        wmNavigationbarView.setLeftViews([dismissButton])
        wmNavigationbarView.setRightViews([lockButton, moreButton, completionButton])
        wmNavigationbarView.addSubview(saveCompletionIndicator)
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

        completionButton.snp.makeConstraints {
            $0.width.equalTo(45)
            $0.height.equalTo(24)
        }

        saveCompletionIndicator.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-35)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(15)
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
                LogManager.analytics(PlaylistAnalyticsLog.clickLockButton(id: reactor.key))
                reactor.action.onNext(.privateButtonDidTap)

            })
            .disposed(by: disposeBag)

        dismissButton.rx
            .tap
            .withLatestFrom(sharedState.map(\.isEditing))
            .bind(with: self) { owner, isEditing in

                let vc = owner.textPopupFactory.makeView(
                    text: "변경된 내용을 저장할까요?",
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
            .throttle(.milliseconds(500), latest: false, scheduler: MainScheduler.asyncInstance)
            .map { Reactor.Action.moreButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        completionButton.rx
            .tap
            .throttle(.seconds(1), latest: false, scheduler: MainScheduler.asyncInstance)
            .do(onNext: { _ in
                LogManager.analytics(CommonAnalyticsLog.clickEditCompleteButton(location: .playlistDetail))
            })
            .map { Reactor.Action.completionButtonDidTap }
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
            }
            .disposed(by: disposeBag)

        headerView.rx.cameraButtonDidTap
            .bind(with: self) { owner, _ in

                LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistCameraButton)
                let vc = owner.playlistCoverOptionPopupFactory.makeView(delegate: owner)

                owner.showBottomSheet(content: vc, size: .fixed(252 + SAFEAREA_BOTTOM_HEIGHT()))
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(with: self) { owner, indexPath in

                guard let model = owner.dataSource.itemIdentifier(for: indexPath) else { return }

                PlayState.shared.append(item: .init(id: model.id, title: model.title, artist: model.artist))
                let playlistIDs = PlayState.shared.currentPlaylist
                    .map(\.id)
                owner.songDetailPresenter.present(ids: playlistIDs, selectedID: model.id)
            }
            .disposed(by: disposeBag)
    }

    override func bindState(reactor: MyPlaylistDetailReactor) {
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

        reactor.pulse(\.$shareLink)
            .compactMap { $0 }
            .bind(with: self) { owner, link in

                let activityViewController = UIActivityViewController(
                    activityItems: [URL(string: link)],
                    applicationActivities: [PlaylistActivity()]
                )
                activityViewController.popoverPresentationController?.sourceView = owner.view
                activityViewController.popoverPresentationController?.sourceRect = CGRect(
                    x: owner.view.bounds.midX,
                    y: owner.view.bounds.midY,
                    width: 0,
                    height: 0
                )
                activityViewController.popoverPresentationController?.permittedArrowDirections = []
                owner.present(activityViewController, animated: true)
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$notiName)
            .compactMap { $0 }
            .bind(with: self) { owner, name in
                NotificationCenter.default.post(name: name, object: nil)
            }
            .disposed(by: disposeBag)

        sharedState.map(\.isEditing)
            .distinctUntilChanged()
            .bind(with: self) { owner, isEditing in
                owner.lockButton.isHidden = isEditing
                owner.moreButton.isHidden = isEditing
                owner.tableView.isEditing = isEditing
                owner.headerView.updateEditState(isEditing)
                owner.navigationController?.interactivePopGestureRecognizer?.delegate = isEditing ? owner : nil
                owner.tableView.reloadData()

                if !isEditing {
                    owner.hideAll()
                }
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

        sharedState.map(\.playlistModels)
            .skip(1)
            .distinctUntilChanged()
            .bind(with: self) { owner, model in
                var snapShot = NSDiffableDataSourceSnapshot<Int, PlaylistItemModel>()

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

        sharedState.map(\.isSaveCompletionLoading)
            .distinctUntilChanged()
            .bind(with: self) { owner, isLoading in
                if isLoading {
                    owner.saveCompletionIndicator.startAnimating()
                } else {
                    owner.saveCompletionIndicator.stopAnimating()
                }
            }
            .disposed(by: disposeBag)

        sharedState.map(\.completionButtonVisible)
            .distinctUntilChanged()
            .map { !$0 }
            .bind(to: completionButton.rx.isHidden)
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

        sharedState.map(\.showEditSheet)
            .distinctUntilChanged()
            .bind(with: self) { owner, flag in

                if flag {
                    owner.showplaylistEditSheet(in: owner.view)
                    owner.playlisteditSheetView?.delegate = owner
                } else {
                    owner.hideplaylistEditSheet()
                }
            }
            .disposed(by: disposeBag)
    }
}

extension MyPlaylistDetailViewController {
    func createDataSource() -> MyPlaylistDetailDataSource {
        let dataSource =
            MyPlaylistDetailDataSource(
                reactor: reactor!,
                tableView: tableView
            ) {
                [weak self] tableView,
                    indexPath,
                    itemIdentifier in

                guard let self,
                      let cell = tableView.dequeueReusableCell(
                          withIdentifier: PlaylistTableViewCell.identifier,
                          for: indexPath
                      ) as? PlaylistTableViewCell else {
                    return UITableViewCell()
                }

                cell.delegate = self
                cell.setContent(
                    model: itemIdentifier,
                    index: indexPath.row,
                    isEditing: tableView.isEditing,
                    isSelected: itemIdentifier.isSelected
                )
                cell.selectionStyle = .none

                return cell
            }

        tableView.dataSource = dataSource

        return dataSource
    }

    func hideAll() {
        hideplaylistEditSheet()
        hideSongCart()
        reactor?.action.onNext(.restore)
    }

    func navigateToCheckPlaylistCover(imageData: Data) {
        if let navigationController = self.presentedViewController as? UINavigationController {
            if Double(imageData.count).megabytes > Limit.imageSizeLimitPerMB {
                let textPopupVC = self.textPopupFactory.makeView(
                    text: "사진의 용량은 \(Int(Limit.imageSizeLimitPerMB))MB를 초과할 수 없습니다.\n다른 사진을 선택해 주세요.",
                    cancelButtonIsHidden: true,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: nil,
                    cancelCompletion: nil
                )

                navigationController.showBottomSheet(content: textPopupVC)
                return
            }
            navigationController.pushViewController(
                self.checkPlaylistCoverFactory.makeView(delegate: self, imageData: imageData),
                animated: true
            )
        }
    }
}

/// 테이블 뷰 델리게이트
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

        if reactor.currentState.playlistModels.isEmpty {
            return nil
        } else {
            return playbuttonGroupView
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let reactor = reactor else {
            return .zero
        }

        if reactor.currentState.playlistModels.isEmpty {
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
}

/// 전체재생 , 랜덤 재생 델리게이트
extension MyPlaylistDetailViewController: PlayButtonGroupViewDelegate {
    func play(_ event: PlayEvent) {
        guard let reactor = reactor else {
            return
        }
        let currentState = reactor.currentState
        var songs = currentState.playlistModels

        let playlistName = reactor.currentState.header.title
        let title: String

        switch event {
        case .allPlay:
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .playlistDetail, type: .all)
            )
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistPlayButton(type: "all", key: reactor.key))
            title = "\(playlistName) (전체)"

        case .shufflePlay:
            LogManager.analytics(
                CommonAnalyticsLog.clickPlayButton(location: .playlistDetail, type: .random)
            )
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistPlayButton(type: "random", key: reactor.key))
            songs.shuffle()
            title = "\(playlistName) (랜덤)"
        }

        PlayState.shared.append(contentsOf: songs.map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) })

        if songs.allSatisfy({ $0.title.isContainShortsTagTitle }) {
            WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직", playPlatform: .youtube).play()
        } else {
            WakmusicYoutubePlayer(ids: songs.map { $0.id }, title: "왁타버스 뮤직").play()
        }
    }
}

/// 편집모드 시 셀 선택 이벤트
extension MyPlaylistDetailViewController: PlaylistTableViewCellDelegate {
    func playButtonDidTap(model: PlaylistItemModel) {
        LogManager.analytics(
            CommonAnalyticsLog.clickPlayButton(location: .playlist, type: .single)
        )
        WakmusicYoutubePlayer(
            id: model.id,
            playPlatform: model.title.isContainShortsTagTitle ? .youtube : .automatic
        ).play()
    }

    func superButtonTapped(index: Int) {
        tableView.deselectRow(at: IndexPath(row: index, section: 0), animated: false)
        reactor?.action.onNext(.itemDidTap(index))
    }
}

/// swipe pop 델리게이트 , 편집모드 시 막기
extension MyPlaylistDetailViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

/// 송카트 델리게이트
extension MyPlaylistDetailViewController: SongCartViewDelegate {
    func buttonTapped(type: SongCartSelectType) {
        guard let reactor = reactor else {
            return
        }

        let currentState = reactor.currentState

        let songs = currentState.playlistModels.filter { $0.isSelected }

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

            let vc = containSongsFactory
                .makeView(songs: songs.map(\.id))
            vc.modalPresentationStyle = .overFullScreen

            self.present(vc, animated: true)

            reactor.action.onNext(.forceEndEditing)

        case .addPlayList:
            reactor.action.onNext(.forceEndEditing)
            PlayState.shared
                .append(contentsOf: songs.map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) })
            showToast(
                text: Localization.LocalizationStrings.addList,
                options: [.tabBar]
            )

        case .play:
            break
        case .remove:

            let vc: UIViewController = textPopupFactory.makeView(
                text: "\(currentState.selectedCount)곡을 삭제하시겠습니까?",
                cancelButtonIsHidden: false, confirmButtonText: "확인",
                cancelButtonText: "취소",
                completion: {
                    reactor.action.onNext(.removeSongs)
                    reactor.action.onNext(.forceEndEditing)
                }, cancelCompletion: {
                    reactor.action.onNext(.forceEndEditing)
                }
            )

            self.showBottomSheet(content: vc)
        }
    }
}

/// 편집 / 공유 바텀시트 델리게이트
extension MyPlaylistDetailViewController: PlaylistEditSheetDelegate {
    func didTap(_ type: PlaylistEditType) {
        switch type {
        case .edit:
            LogManager.analytics(CommonAnalyticsLog.clickEditButton(location: .playlistDetail))
            reactor?.action.onNext(.editButtonDidTap)
        case .share:
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistShareButton)
            reactor?.action.onNext(.shareButtonDidTap)
        }
    }
}

extension MyPlaylistDetailViewController: RequestPermissionable {
    public func showPhotoLibrary() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        configuration.selectionLimit = 1 // 갯수 제한

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self

        let pickerToWrapNavigationController = picker.wrapNavigationController
        pickerToWrapNavigationController.modalPresentationStyle = .overFullScreen
        pickerToWrapNavigationController.setNavigationBarHidden(true, animated: false)

        self.present(pickerToWrapNavigationController, animated: true)
    }
}

/// 갤러리 신버전
extension MyPlaylistDetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if results.isEmpty {
            picker.dismiss(animated: true)
            return
        }

        results.forEach {
            let provider = $0.itemProvider

            if provider.canLoadObject(ofClass: UIImage.self) {
                provider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self else { return }
                    if let error = error {
                        DEBUG_LOG("error: \(error)")

                    } else {
                        DispatchQueue.main.async {
                            guard let image = image as? UIImage,
                                  let resizeImage = image.customizeForPlaylistCover(
                                      targetSize: CGSize(width: 500, height: 500)
                                  ),
                                  var imageData = resizeImage.jpegData(compressionQuality: 1.0)
                            else { return } // 80% 압축

                            let sizeMB: Double = Double(imageData.count).megabytes

                            if sizeMB > Limit.imageSizeLimitPerMB {
                                imageData = image.jpegData(compressionQuality: 0.8) ?? imageData
                            }
                            self.navigateToCheckPlaylistCover(imageData: imageData)
                        }
                    }
                }
            }
        }
    }
}

extension MyPlaylistDetailViewController: PlaylistCoverOptionPopupDelegate {
    func didTap(_ index: Int, _ price: Int) {
        guard let reactor = reactor else {
            return
        }

        let state = reactor.currentState

        if index == 0 {
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistImageButton(type: "default"))
            let vc = defaultPlaylistCoverFactory.makeView(self)
            vc.modalPresentationStyle = .overFullScreen

            self.present(vc, animated: true)

        } else {
            LogManager.analytics(
                PlaylistAnalyticsLog.clickPlaylistImageButton(type: "custom")
            )

            guard let user = PreferenceManager.userInfo else {
                return
            }

            if user.itemCount < price {
                showToast(
                    text: LocalizationStrings.lackOfMoney(price - user.itemCount), options: [.tabBar]
                )
            } else {
                requestPhotoLibraryPermission()
            }
        }
    }
}

extension MyPlaylistDetailViewController: CheckPlaylistCoverDelegate {
    func receive(_ imageData: Data) {
        reactor?.action.onNext(.changeImageData(.custom(data: imageData)))
        headerView.updateThumbnailFromGallery(imageData)
    }
}

extension MyPlaylistDetailViewController: DefaultPlaylistCoverDelegate {
    func receive(url: String, imageName: String) {
        reactor?.action.onNext(.changeImageData(.default(imageName: imageName)))
        headerView.updateThumbnailByDefault(url)
    }
}
