import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import PhotosUI
import PlaylistFeatureInterface
import ReactorKit
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

#warning("공유하기, 이미지 업로드")

final class MyPlaylistDetailViewController: BaseReactorViewController<MyPlaylistDetailReactor>,
    PlaylistEditSheetViewType, SongCartViewType {
    var playlisteditSheetView: PlaylistEditSheetView!

    var songCartView: SongCartView!

    var bottomSheetView: BottomSheetView!

    fileprivate let limitSizePerMB: Double = 10.0
    private let multiPurposePopupFactory: any MultiPurposePopupFactory

    private let containSongsFactory: any ContainSongsFactory

    private let textPopUpFactory: any TextPopUpFactory

    private let thumbnailPopupFactory: any ThumbnailPopupFactory

    private let checkThumbnailFactory: any CheckThumbnailFactory

    private let defaultPlaylistImageFactory: any DefaultPlaylistImageFactory

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

    lazy var dataSource: MyPlaylistDetailDataSource = createDataSource()

    init(
        reactor: MyPlaylistDetailReactor,
        multiPurposePopupFactory: any MultiPurposePopupFactory,
        containSongsFactory: any ContainSongsFactory,
        textPopUpFactory: any TextPopUpFactory,
        thumbnailPopupFactory: any ThumbnailPopupFactory,
        checkThumbnailFactory: any CheckThumbnailFactory,
        defaultPlaylistImageFactory: any DefaultPlaylistImageFactory
    ) {
        self.multiPurposePopupFactory = multiPurposePopupFactory
        self.containSongsFactory = containSongsFactory
        self.textPopUpFactory = textPopUpFactory
        self.thumbnailPopupFactory = thumbnailPopupFactory
        self.checkThumbnailFactory = checkThumbnailFactory
        self.defaultPlaylistImageFactory = defaultPlaylistImageFactory

        super.init(reactor: reactor)
    }

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = DesignSystemAsset.BlueGrayColor.gray100.color
        reactor?.action.onNext(.viewDidLoad)
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        LogManager.analytics(CommonAnalyticsLog.viewPage(pageName: .myPlaylistDetail))
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        hideAll()
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
                LogManager.analytics(PlaylistAnalyticsLog.clickLockButton(id: reactor.key))
                reactor.action.onNext(.privateButtonDidTap)

            })
            .disposed(by: disposeBag)

        dismissButton.rx
            .tap
            .withLatestFrom(sharedState.map(\.isEditing))
            .bind(with: self) { owner, isEditing in

                let vc = owner.textPopUpFactory.makeView(
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

                owner.showBottomSheet(content: vc, size: .fixed(252 + SAFEAREA_BOTTOM_HEIGHT()))
            }
            .disposed(by: disposeBag)

        headerView.rx.cameraButtonDidTap
            .bind(with: self) { owner, _ in

                LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistCameraButton)
                let vc = owner.thumbnailPopupFactory.makeView(delegate: owner)

                owner.showBottomSheet(content: vc, size: .fixed(252 + SAFEAREA_BOTTOM_HEIGHT()))
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

        sharedState.map(\.replaceThumnbnailData)
            .compactMap { $0 }
            .bind(with: self) { owner, data in

                if Double(data.count).megabytes > owner.limitSizePerMB {
                    let textPopupVC = owner.textPopUpFactory.makeView(
                        text: "업로드에 실패했습니다.\n파일당 10MB까지 업로드할 수 있습니다.",
                        cancelButtonIsHidden: true,
                        confirmButtonText: nil,
                        cancelButtonText: nil,
                        completion: nil,
                        cancelCompletion: nil
                    )

                    owner.showBottomSheet(content: textPopupVC)
                    return
                }

                if let navigationController = owner.presentedViewController as? UINavigationController {
                    navigationController.pushViewController(
                        owner.checkThumbnailFactory.makeView(delegate: owner, imageData: data), animated: true
                    )
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DEBUG_LOG("HELLo")
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

        switch event {
        case .allPlay:
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistPlayButton(type: "all", key: reactor.key))

        case .shufflePlay:
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistPlayButton(type: "random", key: reactor.key))
            songs.shuffle()
        }

        PlayState.shared.append(contentsOf: songs.map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) })
        WakmusicYoutubePlayer(ids: songs.map { $0.id }).play()
    }
}

/// 편집모드 시 셀 선택 이벤트
extension MyPlaylistDetailViewController: PlaylistTableViewCellDelegate {
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
            let vc = containSongsFactory
                .makeView(songs: songs.map(\.id))
            vc.modalPresentationStyle = .overFullScreen

            self.present(vc, animated: true)

            reactor.action.onNext(.forceEndEditing)

            break
        case .addPlayList:
            reactor.action.onNext(.forceEndEditing)
            PlayState.shared
                .append(contentsOf: songs.map { PlaylistItem(id: $0.id, title: $0.title, artist: $0.artist) })
            showToast(
                text: Localization.LocalizationStrings.addList,

                font: .setFont(.t6(weight: .light)),
                verticalOffset: 56 + 10
            )

        case .play:
            break
        case .remove:

            let vc: UIViewController = textPopUpFactory.makeView(
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
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistEditButton)
            reactor?.action.onNext(.editButtonDidTap)
        case .share:
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistShareButton)
            #warning("공유 작업")
            break
        }

        self.hideplaylistEditSheet()
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
        picker.dismiss(animated: true)

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
                                  var imageRawData = image.jpegData(compressionQuality: 1.0) else { return } // 80% 압축

                            let sizeMB: Double = Double(imageRawData.count).megabytes

                            if sizeMB > self.limitSizePerMB {
                                imageRawData = image.jpegData(compressionQuality: 0.8) ?? imageRawData
                            }
                            self.reactor?.action.onNext(.changeThumnail(imageRawData))
                        }
                    }
                }
            }
        }
    }
}

extension MyPlaylistDetailViewController: ThumbnailPopupDelegate {
    func didTap(_ index: Int, _ cost: Int) {
        if index == 0 {
            LogManager.analytics(PlaylistAnalyticsLog.clickPlaylistImageButton(type: "default"))
            let vc = defaultPlaylistImageFactory.makeView(self)
            vc.modalPresentationStyle = .overFullScreen

            self.present(vc, animated: true)

        } else {
            LogManager.analytics(
                PlaylistAnalyticsLog.clickPlaylistImageButton(type: "custom")
            )
            requestPhotoLibraryPermission()
        }
    }
}

extension MyPlaylistDetailViewController: CheckThumbnailDelegate {
    func receive(_ imageData: Data) {
        headerView.updateThumbnailFromGallery(imageData)
    }
}

extension MyPlaylistDetailViewController: DefaultPlaylistImageDelegate {
    func receive(_ name: String, _ url: String) {
        headerView.updateThumbnailByDefault(url)
    }
}
