import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import NVActivityIndicatorView
import RxCocoa
import RxSwift
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
        containSongsFactory: ContainSongsFactory
    ) -> NewSongsContentViewController {
        let viewController = NewSongsContentViewController.viewController(
            storyBoardName: "Home",
            bundle: Bundle.module
        )
        viewController.viewModel = viewModel
        viewController.containSongsFactory = containSongsFactory
        return viewController
    }
}

private extension NewSongsContentViewController {
    func inputBind() {
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
            .bind(to: tableView.rx.items) { tableView, index, model -> UITableViewCell in
                let indexPath: IndexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: "NewSongsCell",
                    for: indexPath
                ) as? NewSongsCell else {
                    return UITableViewCell()
                }
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
        tableView.backgroundColor = .clear
        tableView.refreshControl = refreshControl
        tableView.sectionHeaderTopPadding = 0
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
        #warning("TO-DO:: 액션 수정해야함")
        input.groupPlayTapped.onNext(PlayEvent.allPlay)
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
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowContainWarning)
                return
            }
            let songIds: [String] = songs.map { $0.id }
            let viewController = containSongsFactory.makeView(songs: songIds)
            viewController.modalPresentationStyle = .overFullScreen
            self.present(viewController, animated: true) {
                self.input.allSongSelected.onNext(false)
            }

        case .addPlayList:
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowAddPlaylistWarning)
                return
            }
            PlayState.shared.appendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)

        case .play:
            guard songs.count <= limit else {
                output.showToast.onNext(LocalizationStrings.overFlowPlayWarning)
                return
            }
            PlayState.shared.loadAndAppendSongsToPlaylist(songs)
            input.allSongSelected.onNext(false)

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
