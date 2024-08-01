import ArtistFeatureInterface
import BaseFeature
import DesignSystem
import HomeFeatureInterface
import LogManager
import MusicDetailFeatureInterface
import MyInfoFeatureInterface
import NoticeDomainInterface
import PlaylistFeatureInterface
import RxCocoa
import RxSwift
import SafariServices
import SearchFeatureInterface
import SnapKit
import StorageFeatureInterface
import UIKit
import Utility

public final class MainTabBarViewController: BaseViewController, ViewControllerFromStoryBoard, ContainerViewType {
    @IBOutlet public weak var contentView: UIView!

    private var previousIndex: Int?
    private var selectedIndex: Int = Utility.PreferenceManager.startPage ?? 0
    private lazy var viewControllers: [UIViewController] = {
        return [
            homeFactory.makeView().wrapNavigationController,
            searchFactory.makeView().wrapNavigationController,
            artistFactory.makeView().wrapNavigationController,
            storageFactory.makeView().wrapNavigationController,
            myInfoFactory.makeView().wrapNavigationController
        ]
    }()

    private var viewModel: MainTabBarViewModel!
    private lazy var input = MainTabBarViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag: DisposeBag = DisposeBag()

    private var appEntryState: AppEntryStateHandleable!
    private var homeFactory: HomeFactory!
    private var searchFactory: SearchFactory!
    private var artistFactory: ArtistFactory!
    private var storageFactory: StorageFactory!
    private var myInfoFactory: MyInfoFactory!
    private var noticePopupComponent: NoticePopupComponent!
    private var noticeDetailFactory: NoticeDetailFactory!
    private var playlistDetailFactory: PlaylistDetailFactory!
    private var musicDetailFactory: MusicDetailFactory!
    private var songDetailPresenter: SongDetailPresentable!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
        entryBind()
    }

    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }

    override public func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    public static func viewController(
        viewModel: MainTabBarViewModel,
        appEntryState: AppEntryStateHandleable,
        homeFactory: HomeFactory,
        searchFactory: SearchFactory,
        artistFactory: ArtistFactory,
        storageFactory: StorageFactory,
        myInfoFactory: MyInfoFactory,
        noticePopupComponent: NoticePopupComponent,
        noticeDetailFactory: NoticeDetailFactory,
        playlistDetailFactory: PlaylistDetailFactory,
        musicDetailFactory: MusicDetailFactory,
        songDetailPresenter: SongDetailPresentable
    ) -> MainTabBarViewController {
        let viewController = MainTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.appEntryState = appEntryState
        viewController.homeFactory = homeFactory
        viewController.searchFactory = searchFactory
        viewController.artistFactory = artistFactory
        viewController.storageFactory = storageFactory
        viewController.myInfoFactory = myInfoFactory
        viewController.noticePopupComponent = noticePopupComponent
        viewController.noticeDetailFactory = noticeDetailFactory
        viewController.playlistDetailFactory = playlistDetailFactory
        viewController.musicDetailFactory = musicDetailFactory
        viewController.songDetailPresenter = songDetailPresenter
        return viewController
    }
}

private extension MainTabBarViewController {
    func entryBind() {
        appEntryState.moveSceneObservable
            .debug("moveSceneObservable")
            .filter { !$0.isEmpty }
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(with: self, onNext: { owner, params in
                owner.moveScene(params: params)
            })
            .disposed(by: disposeBag)

        songDetailPresenter.presentSongDetailObservable
            .bind(with: self, onNext: { owner, selection in
                let viewController = owner.musicDetailFactory.makeViewController(
                    songIDs: selection.ids,
                    selectedID: selection.selectedID
                )
                viewController.modalPresentationStyle = .fullScreen
                owner.present(viewController, animated: true)
            })
            .disposed(by: disposeBag)
    }

    func moveScene(params: [String: Any]) {
        let page = params["page"] as? String ?? ""
        let navigationController = viewControllers[selectedIndex] as? UINavigationController

        switch page {
        case "playlist":
            let key: String = params["key"] as? String ?? ""
            let viewController = playlistDetailFactory.makeView(key: key)
            navigationController?.pushViewController(viewController, animated: true)

        default:
            break
        }
    }
}

private extension MainTabBarViewController {
    func inputBind() {
        input.fetchNoticePopup.onNext(())
        input.fetchNoticeIDList.onNext(())
    }

    func outputBind() {
        output.dataSource
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, model in
                let viewController = owner.noticePopupComponent.makeView(model: model)
                viewController.delegate = owner
                owner.showBottomSheet(content: viewController)
            }
            .disposed(by: disposeBag)
    }

    func configureUI() {
        let startPage: Int = Utility.PreferenceManager.startPage ?? 0
        add(asChildViewController: viewControllers[startPage])
    }
}

extension MainTabBarViewController {
    func updateContent(previous: Int, current: Int) {
        Utility.PreferenceManager.startPage = current
        remove(asChildViewController: viewControllers[previous])
        add(asChildViewController: viewControllers[current])

        self.previousIndex = previous
        self.selectedIndex = current
    }

    func equalHandleTapped(for index: Int) {
        guard let navigationController = self.viewControllers[index] as? UINavigationController,
              let viewController = navigationController.viewControllers.first as? EqualHandleTappedType else {
            return
        }
        viewController.equalHandleTapped()
    }
}

extension MainTabBarViewController: NoticePopupViewControllerDelegate {
    public func noticeTapped(model: FetchNoticeEntity) {
        if model.thumbnail.link.isEmpty {
            let viewController = noticeDetailFactory.makeView(model: model)
            viewController.modalPresentationStyle = .fullScreen
            present(viewController, animated: true)

        } else {
            guard let URL = URL(string: model.thumbnail.link) else { return }
            present(SFSafariViewController(url: URL), animated: true)
        }
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
