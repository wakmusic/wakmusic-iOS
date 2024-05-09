import ArtistFeature
import BaseFeature
import ChartFeature
import DesignSystem
import HomeFeature
import MyInfoFeature
import NoticeDomainInterface
import RxCocoa
import RxSwift
import SearchFeature
import SearchFeatureInterface
import SnapKit
import StorageFeature
import UIKit
import Utility
import StorageFeatureInterface

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

    var viewModel: MainTabBarViewModel!
    private var previousIndex: Int?
    private var selectedIndex: Int = Utility.PreferenceManager.startPage ?? 0
    private var disposeBag: DisposeBag = DisposeBag()

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
        bind()
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

extension MainTabBarViewController {
    private func bind() {
        viewModel.output
            .dataSource
            .filter { !$0.isEmpty }
            .withUnretained(self)
            .subscribe(onNext: { owner, model in
                let viewController = owner.noticePopupComponent.makeView(model: model)
                viewController.delegate = owner
                owner.showPanModal(content: viewController)
            }).disposed(by: disposeBag)
    }

    private func configureUI() {
        let startPage: Int = Utility.PreferenceManager.startPage ?? 0
        add(asChildViewController: viewControllers[startPage])
    }

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
        let viewController = noticeDetailComponent.makeView(model: model)
        viewController.modalPresentationStyle = .overFullScreen
        self.present(viewController, animated: true)
    }
}

extension MainTabBarViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
