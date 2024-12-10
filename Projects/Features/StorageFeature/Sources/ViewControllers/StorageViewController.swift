import BaseFeature
import BaseFeatureInterface
import DesignSystem
import Localization
import LogManager
import Pageboy
import ReactorKit
import RxSwift
import SignInFeatureInterface
import Tabman
import UIKit
import Utility

final class StorageViewController: TabmanViewController, @preconcurrency View {
    typealias Reactor = StorageReactor
    var disposeBag = DisposeBag()

    private var bottomSheetView: BottomSheetView!
    private var listStorageComponent: ListStorageComponent!
    private var multiPurposePopupFactory: MultiPurposePopupFactory!
    private var likeStorageComponent: LikeStorageComponent!
    private var textPopupFactory: TextPopupFactory!
    private var signInFactory: SignInFactory!

    private var viewControllers: [UIViewController]!
    let storageView = StorageView()
    let bar = TMBar.ButtonBar()

    init(reactor: Reactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = storageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        reactor?.action.onNext(.viewDidLoad)
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
        reactor: Reactor,
        listStorageComponent: ListStorageComponent,
        multiPurposePopupFactory: MultiPurposePopupFactory,
        likeStorageComponent: LikeStorageComponent,
        textPopupFactory: TextPopupFactory,
        signInFactory: SignInFactory
    ) -> StorageViewController {
        let viewController = StorageViewController(reactor: reactor)

        viewController.listStorageComponent = listStorageComponent
        viewController.multiPurposePopupFactory = multiPurposePopupFactory
        viewController.likeStorageComponent = likeStorageComponent
        viewController.viewControllers = [listStorageComponent.makeView(), likeStorageComponent.makeView()]
        viewController.textPopupFactory = textPopupFactory
        viewController.signInFactory = signInFactory
        return viewController
    }

    /// 탭맨 페이지 변경 감지 함수
    override public func pageboyViewController(
        _ pageboyViewController: PageboyViewController,
        didScrollToPageAt index: TabmanViewController.PageIndex,
        direction: PageboyViewController.NavigationDirection,
        animated: Bool
    ) {
        self.reactor?.action.onNext(.switchTab(index))
        // 탭 이동 간 플로팅 버튼 위치 조정
        NotificationCenter.default.post(
            name: .shouldMovePlaylistFloatingButton,
            object: index == 0 ?
                PlaylistFloatingButtonPosition.top :
                PlaylistFloatingButtonPosition.default
        )
    }

    /// 탭맨 탭 터치 이벤트 감지 함수
    override func bar(_ bar: any TMBar, didRequestScrollTo index: PageboyViewController.PageIndex) {
        super.bar(bar, didRequestScrollTo: index)

        guard let viewController = viewControllers[safe: index] else { return }
        switch viewController {
        case is ListStorageViewController:
            LogManager.analytics(StorageAnalyticsLog.clickStorageTabbarTab(tab: .myPlaylist))
        case is LikeStorageViewController:
            LogManager.analytics(StorageAnalyticsLog.clickStorageTabbarTab(tab: .myLikeList))
        default:
            break
        }
    }
}

extension StorageViewController {
    func bind(reactor: Reactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }

    func bindState(reactor: Reactor) {
        reactor.state.map(\.isEditing)
            .distinctUntilChanged()
            .bind(with: self) { owner, isEditing in
                owner.storageView.updateIsHiddenEditButton(isHidden: isEditing)
                owner.isScrollEnabled = isEditing ? false : true
                owner.bar.isUserInteractionEnabled = isEditing ? false : true
            }
            .disposed(by: disposeBag)

        reactor.pulse(\.$showLoginAlert)
            .compactMap { $0 }
            .bind(with: self, onNext: { owner, entry in
                guard let vc = owner.textPopupFactory.makeView(
                    text: LocalizationStrings.needLoginWarning,
                    cancelButtonIsHidden: false,
                    confirmButtonText: nil,
                    cancelButtonText: nil,
                    completion: {
                        let log = CommonAnalyticsLog.clickLoginButton(entry: entry)
                        LogManager.analytics(log)

                        let loginVC = owner.signInFactory.makeView()
                        loginVC.modalPresentationStyle = .fullScreen
                        owner.present(loginVC, animated: true)
                    },
                    cancelCompletion: {}
                ) as? TextPopupViewController else {
                    return
                }
                owner.showBottomSheet(content: vc)
            })
            .disposed(by: disposeBag)
    }

    func bindAction(reactor: Reactor) {
        storageView.rx.editButtonDidTap
            .do(onNext: {
                let tabIndex = reactor.currentState.tabIndex
                switch tabIndex {
                case 0: LogManager.analytics(StorageAnalyticsLog.clickMyPlaylistEditButton)
                case 1: LogManager.analytics(StorageAnalyticsLog.clickMyLikeListEditButton)
                default: break
                }
            })
            .map { Reactor.Action.editButtonDidTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        storageView.rx.saveButtonDidTap
            .map { Reactor.Action.saveButtonTap }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
}

private extension StorageViewController {
    func configureUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        // 탭바 설정
        self.dataSource = self

        // 배경색
        bar.backgroundView.style = .flat(color: .clear)

        // 간격 설정
        bar.layout.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)

        bar.layout.contentMode = .intrinsic
        bar.layout.transitionStyle = .progressive
        bar.layout.interButtonSpacing = 24

        // 버튼 글씨 커스텀
        bar.buttons.customize { button in
            button.tintColor = DesignSystemAsset.BlueGrayColor.blueGray400.color
            button.selectedTintColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
            button.font = .WMFontSystem.t5(weight: .medium).font
            button.selectedFont = .WMFontSystem.t5(weight: .bold).font
        }

        // indicator
        bar.indicator.weight = .custom(value: 2)
        bar.indicator.tintColor = DesignSystemAsset.PrimaryColor.point.color
        bar.indicator.overscrollBehavior = .compress
        addBar(bar, dataSource: self, at: .custom(view: storageView.tabBarView, layout: nil))
    }
}

extension StorageViewController: @preconcurrency PageboyViewControllerDataSource, @preconcurrency TMBarDataSource {
    public func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
        self.viewControllers.count
    }

    public func viewController(
        for pageboyViewController: Pageboy.PageboyViewController,
        at index: Pageboy.PageboyViewController.PageIndex
    ) -> UIViewController? {
        return viewControllers[safe: index]
    }

    public func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController
        .Page? {
        nil
    }

    public func barItem(for bar: Tabman.TMBar, at index: Int) -> Tabman.TMBarItemable {
        switch index {
        case 0:
            return TMBarItem(title: "내 리스트")
        case 1:
            return TMBarItem(title: "좋아요")
        default:
            let title = "Page \(index)"
            return TMBarItem(title: title)
        }
    }
}

extension StorageViewController: EqualHandleTappedType {
    func scrollToTop() {
        let current: Int = self.currentIndex ?? 0
        guard self.viewControllers.count > current else { return }
        if let listVC = self.viewControllers[current] as? ListStorageViewController {
            listVC.scrollToTop()
        } else if let likeVC = self.viewControllers[current] as? LikeStorageViewController {
            likeVC.scrollToTop()
        }
    }

    public nonisolated func equalHandleTapped() {
        Task { @MainActor in
            let viewControllersCount: Int = self.navigationController?.viewControllers.count ?? 0
            if viewControllersCount > 1 {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                scrollToTop()
            }
        }
    }
}

extension StorageViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
