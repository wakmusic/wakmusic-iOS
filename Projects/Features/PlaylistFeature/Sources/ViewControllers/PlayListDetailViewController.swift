import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Kingfisher
import NVActivityIndicatorView
import PanModal
import ReactorKit
import RxCocoa
import RxDataSources
import RxRelay
import RxSwift
import SongsDomainInterface
import UIKit
import Utility

public typealias PlayListDetailSectionModel = SectionModel<Int, SongEntity>

// TODO: 커스텀 플리 확인
// TODO: songCart

public class PlayListDetailViewController: BaseStoryboardReactorViewController<PlaylistDetailReactor>,
    SongCartViewType,
    EditSheetViewType {
    typealias Reactor = PlaylistDetailReactor

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var playListImage: UIImageView!
    @IBOutlet weak var playListNameLabel: UILabel!
    @IBOutlet weak var playListCountLabel: UILabel!
    @IBOutlet weak var editPlayListNameButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var editStateLabel: UILabel!
    @IBOutlet weak var playListInfoView: UIView!
    @IBOutlet weak var playListInfoSuperView: UIView!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    var multiPurposePopUpFactory: MultiPurposePopUpFactory!
    var containSongsComponent: ContainSongsComponent!

    public var editSheetView: EditSheetView!
    public var songCartView: SongCartView!
    public var bottomSheetView: BottomSheetView!

    let playState = PlayState.shared

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        DEBUG_LOG("\(Self.self) deinit")
    }

    public static func viewController(
        reactor: PlaylistDetailReactor,
        multiPurposePopUpFactory: MultiPurposePopUpFactory,
        containSongsComponent: ContainSongsComponent
    ) -> PlayListDetailViewController {
        let viewController = PlayListDetailViewController.viewController(
            storyBoardName: "Playlist",
            bundle: Bundle.module
        )

        viewController.reactor = reactor

        viewController.multiPurposePopUpFactory = multiPurposePopUpFactory
        viewController.containSongsComponent = containSongsComponent

        return viewController
    }

    override public func configureUI() {
        super.configureUI()

        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 56))

        tableView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 56, right: 0)

        view.backgroundColor = DesignSystemAsset.GrayColor.gray100.color
        activityIndicator.color = DesignSystemAsset.PrimaryColor.point.color
        activityIndicator.type = .circleStrokeSpin
        activityIndicator.startAnimating()

        completeButton.isHidden = true
        editStateLabel.isHidden = true
        editPlayListNameButton.isHidden = true

        backButton.setImage(DesignSystemAsset.Navigation.back.image, for: .normal)
        moreButton.setImage(DesignSystemAsset.Storage.more.image, for: .normal)

        completeButton.titleLabel?.text = "완료"
        completeButton.titleLabel?.font = DesignSystemFontFamily.Pretendard.bold.font(size: 12)
        completeButton.layer.cornerRadius = 4
        completeButton.layer.borderColor = DesignSystemAsset.PrimaryColor.point.color.cgColor
        completeButton.layer.borderWidth = 1
        completeButton.backgroundColor = .clear

        editStateLabel.text = "편집"
        editStateLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        editStateLabel.setTextWithAttributes(kernValue: -0.5)

        playListCountLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 14)
        playListCountLabel.textColor = DesignSystemAsset.GrayColor.gray900.color
            .withAlphaComponent(0.6) // opacity 60%
        playListCountLabel.setTextWithAttributes(kernValue: -0.5)

        playListNameLabel.font = DesignSystemFontFamily.Pretendard.bold.font(size: 20)
        playListNameLabel.setTextWithAttributes(kernValue: -0.5)

        playListInfoView.layer.borderWidth = 1
        playListInfoView.layer.borderColor = colorFromRGB(0xFCFCFD).cgColor
        playListInfoView.layer.cornerRadius = 8

        playListImage.layer.cornerRadius = 12

        moreButton.isHidden = false
        // reactor?.type == .wmRecommend
    }

    override public func bind(reactor: PlaylistDetailReactor) {
        super.bind(reactor: reactor)

        tableView.rx.setDelegate(self)
            .disposed(by: disposeBag)

        tableView.register(
            UINib(nibName: "SongListCell", bundle: BaseFeatureResources.bundle),
            forCellReuseIdentifier: "SongListCell"
        )
    }

    override public func bindState(reactor: PlaylistDetailReactor) {
        super.bindState(reactor: reactor)

        let currentState = reactor.state

        currentState.map(\.dataSource)
            .do(onNext: { [weak self] model in
                self?.activityIndicator.stopAnimating()
                let warningView = WarningView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: APP_HEIGHT() / 3))
                warningView.text = "리스트에 곡이 없습니다."
                let items = model.first?.items ?? []
                self?.tableView.tableFooterView = items.isEmpty ? warningView : UIView(frame: CGRect(
                    x: 0,
                    y: 0,
                    width: APP_WIDTH(),
                    height: 56
                ))
            })
            .bind(to: tableView.rx.items(dataSource: createDatasources()))
            .disposed(by: disposeBag)

        currentState.map(\.header)
            .do(onNext: { [weak self] _ in
                guard let self = self else { return }
                let imageHeight: CGFloat = (140.0 * APP_WIDTH()) / 375.0
                let newFrame: CGRect = CGRect(x: 0, y: 0, width: APP_WIDTH(), height: imageHeight + 20)
                self.tableView.tableHeaderView?.frame = newFrame
            })
            .subscribe(onNext: { [weak self] model in

                guard let self else { return }

                self.playListImage.kf.setImage(
                    with: self.reactor?.type == .wmRecommend ? WMImageAPI.fetchRecommendPlayListWithSquare(
                        id: model.image,
                        version: model.version
                    ).toURL : WMImageAPI.fetchPlayList(id: model.image, version: model.version).toURL,
                    placeholder: nil,
                    options: [.transition(.fade(0.2))]
                )
                self.playListCountLabel.text = model.songCount
                self.playListNameLabel.text = model.title
                self.editPlayListNameButton.setImage(DesignSystemAsset.Storage.storageEdit.image, for: .normal)

            })
            .disposed(by: disposeBag)

        currentState.map(\.selectedItemCount)
            .subscribe(onNext: { [weak self] count in

                guard let self, let type = self.reactor?.type else {
                    return
                }

                switch type {
                case .custom:
                    break
                case .wmRecommend:
                    if count == 0 {
                        self.hideSongCart()
                    } else {
                        self.showSongCart(
                            in: self.view,
                            type: .WMPlayList,
                            selectedSongCount: count,
                            totalSongCount: self.reactor?.currentState.dataSource.first?.items.count ?? 0,
                            useBottomSpace: false
                        )
                        self.songCartView?.delegate = self
                    }
                }

            })
            .disposed(by: disposeBag)

        currentState.map(\.isEditing)
            .subscribe(onNext: { [weak self] flag in

                guard let self else { return }

                self.navigationController?.interactivePopGestureRecognizer?.delegate = flag ? self : nil
                self.moreButton.isHidden = flag
                self.editPlayListNameButton.isHidden = !flag
                self.editStateLabel.isHidden = !flag
                self.completeButton.isHidden = !flag

                tableView.isEditing = flag
                tableView.reloadData()

            })
            .disposed(by: disposeBag)
    }

    override public func bindAction(reactor: PlaylistDetailReactor) {
        super.bindAction(reactor: reactor)

        reactor.action.onNext(.viewDidLoad)
        
        tableView.rx.itemSelected
            .filter { _ in reactor.type == .wmRecommend }
            .map { $0.row }
            .subscribe(onNext: {
                reactor.action.onNext(.tapSong($0))
            })
            .disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .subscribe(onNext: {
                reactor.action.onNext(.itemMoved($0))
            })
            .disposed(by: disposeBag)
        

        moreButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { owner, _ in

                owner.showEditSheet(in: owner.view, type: .playList)
                owner.editSheetView.delegate = owner
            })
            .disposed(by: disposeBag)

        backButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: { [weak self] _ in

                guard let self, let isEditing = self.reactor?.currentState.isEditing else {
                    return
                }

                if isEditing {
                    let vc = TextPopupViewController.viewController(
                        text: "변경된 내용을 저장할까요?",
                        cancelButtonIsHidden: false,
                        completion: {},
                        cancelCompletion: {
                            self.reactor?.action.onNext(.undo)
                        }
                    )
                    self.showPanModal(content: vc)

                } else {
                    self.navigationController?.popViewController(animated: true)
                }

            })
            .disposed(by: disposeBag)
        
        // 저장 버튼 동작
        
        
    
        
    }
}

extension PlayListDetailViewController {
    private func createDatasources() -> RxTableViewSectionedReloadDataSource<PlayListDetailSectionModel> {
        let datasource = RxTableViewSectionedReloadDataSource<PlayListDetailSectionModel>(
            configureCell: { [weak self] _, tableView, indexPath, model -> UITableViewCell in
                guard let self = self, let reactor = self.reactor else { return UITableViewCell() }

                let isEditing = reactor.currentState.isEditing

                switch reactor.type {
                case .custom:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "PlayListTableViewCell",
                        for: IndexPath(row: indexPath.row, section: 0)
                    ) as? PlayListTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.update(model, isEditing, index: indexPath.row)
                    cell.delegate = self
                    return cell

                case .wmRecommend:
                    guard let cell = tableView.dequeueReusableCell(
                        withIdentifier: "SongListCell",
                        for: IndexPath(row: indexPath.row, section: 0)
                    ) as? SongListCell else {
                        return UITableViewCell()
                    }
                    cell.update(model)
                    return cell

                case .none:
                    return UITableViewCell()
                }

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

extension PlayListDetailViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PlayButtonGroupView(frame: CGRect(x: 0, y: 0, width: APP_WIDTH(), height: 80))
        view.delegate = self
        let items = reactor?.currentState.dataSource.first?.items ?? []
        return items.isEmpty ? nil : view
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let items = reactor?.currentState.dataSource.first?.items ?? []
        return items.isEmpty ? 0 : 80
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    public func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell
        .EditingStyle {
        return .none // 편집모드 시 왼쪽 버튼을 숨기려면 .none을 리턴합니다.
    }

    public func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false // 편집모드 시 셀의 들여쓰기를 없애려면 false를 리턴합니다.
    }
}

extension PlayListDetailViewController: SongCartViewDelegate {
    public func buttonTapped(type: SongCartSelectType) {
        #warning("SongCart 나머지 기능 구현")

        switch type {
        case let .allSelect(flag: flag):
            reactor?.action.onNext(.tapAll(flag))
        case .addSong:
            break
        case .addPlayList:
            break
        case .play:
            break
        case .remove:
            break
        }
    }
}

extension PlayListDetailViewController: EditSheetViewDelegate {
    public func buttonTapped(type: EditSheetSelectType) {
        switch type {
        case .edit:
            reactor?.action.onNext(.tapEdit)
        case .share:
            break
        case .profile:
            break
        case .nickname:
            break
        }
    }
}

extension PlayListDetailViewController: PlayListCellDelegate {
    public func buttonTapped(type: PlayListCellDelegateConstant) {}
}

extension PlayListDetailViewController: PlayButtonGroupViewDelegate {
    public func play(_ event: BaseFeature.PlayEvent) {}
}

extension PlayListDetailViewController: PlayButtonDelegate {
    public func play(model: SongEntity) {}
}

extension PlayListDetailViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
