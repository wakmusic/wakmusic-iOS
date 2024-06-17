import ArtistFeature
import BaseFeature
import ChartFeature
import DesignSystem
import HomeFeature
import MyInfoFeature
import NoticeDomainInterface
import RxCocoa
import RxSwift
import SafariServices
import SearchFeature
import SearchFeatureInterface
import SnapKit
import StorageFeature
import StorageFeatureInterface
import UIKit
import Utility

public final class MainTabBarViewController: BaseViewController, ViewControllerFromStoryBoard, ContainerViewType {
    @IBOutlet public weak var contentView: UIView!

    private lazy var viewControllers: [UIViewController] = {
        return [
            homeComponent.makeView().wrapNavigationController,
            chartComponent.makeView().wrapNavigationController,
            searchFactory.makeView().wrapNavigationController,
            artistComponent.makeView().wrapNavigationController,
            storageFactory.makeView().wrapNavigationController,
            myInfoComponent.makeView().wrapNavigationController
        ]
    }()

    private var viewModel: MainTabBarViewModel!
    private lazy var input = MainTabBarViewModel.Input()
    private lazy var output = viewModel.transform(from: input)
    private let disposeBag: DisposeBag = DisposeBag()

    private var previousIndex: Int?
    private var selectedIndex: Int = Utility.PreferenceManager.startPage ?? 0

    private var homeComponent: HomeComponent!
    private var chartComponent: ChartComponent!
    private var searchFactory: SearchFactory!
    private var artistComponent: ArtistComponent!
    private var storageFactory: StorageFactory!
    private var myInfoComponent: MyInfoComponent!
    private var noticePopupComponent: NoticePopupComponent!
    private var noticeComponent: NoticeComponent!
    private var noticeDetailComponent: NoticeDetailComponent!

    override public func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        outputBind()
        inputBind()
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
        homeComponent: HomeComponent,
        chartComponent: ChartComponent,
        searchFactory: SearchFactory,
        artistComponent: ArtistComponent,
        storageFactory: StorageFactory,
        myInfoComponent: MyInfoComponent,
        noticePopupComponent: NoticePopupComponent,
        noticeComponent: NoticeComponent,
        noticeDetailComponent: NoticeDetailComponent
    ) -> MainTabBarViewController {
        let viewController = MainTabBarViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        viewController.viewModel = viewModel
        viewController.homeComponent = homeComponent
        viewController.chartComponent = chartComponent
        viewController.searchFactory = searchFactory
        viewController.artistComponent = artistComponent
        viewController.storageFactory = storageFactory
        viewController.myInfoComponent = myInfoComponent
        viewController.noticePopupComponent = noticePopupComponent
        viewController.noticeComponent = noticeComponent
        viewController.noticeDetailComponent = noticeDetailComponent
        return viewController
    }
}

private extension MainTabBarViewController {
    func inputBind() {
        input.fetchNoticePopup.onNext(())
    }

    func outputBind() {
        output.dataSource
            .filter { !$0.isEmpty }
            .bind(with: self) { owner, model in
                let viewController = owner.noticePopupComponent.makeView(model: model)
                viewController.delegate = owner
                owner.showFittedSheets(content: viewController)
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

    func forceUpdateContent(for index: Int) {
        Utility.PreferenceManager.startPage = index

        if let previous = self.previousIndex {
            remove(asChildViewController: viewControllers[previous])
        }
        add(asChildViewController: viewControllers[index])

        self.previousIndex = self.selectedIndex
        self.selectedIndex = index
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
            let viewController = noticeDetailComponent.makeView(model: model)
            viewController.modalPresentationStyle = .overFullScreen
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
