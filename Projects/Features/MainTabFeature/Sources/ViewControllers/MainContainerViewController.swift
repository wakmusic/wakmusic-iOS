import ArtistFeature
import BaseFeature
import DesignSystem
import PlayerFeature
import RxSwift
import SnapKit
import SongsDomainInterface
import UIKit
import PlaylistFeatureInterface
import Utility

open class MainContainerViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var bottomContainerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var panelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var safeAreaBottomView: UIView!
    @IBOutlet weak var safeAreaBottomViewHeightConstraint: NSLayoutConstraint!
    private let playlistFloatingActionButton = PlayListFloatingActionButton()

    var originalPanelAlpha: CGFloat = 0
    var originalPanelPosition: CGFloat = 0
    var lastPoint: CGPoint = .zero
    var originalTabBarPosition: CGFloat = 0

    var bottomTabBarComponent: BottomTabBarComponent!
    var mainTabBarComponent: MainTabBarComponent!
    var playerComponent: PlayerComponent!
    var playlistFactory: PlaylistFactory!
    var playlistPresenterGlobalState: PlayListPresenterGlobalStateProtocol!

    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(panGesture(_:))
        )
        self.panelView.addGestureRecognizer(gesture)
        return gesture
    }()

    var isDarkContentBackground: Bool = false

    var disposeBag = DisposeBag()

    override open func viewDidLoad() {
        super.viewDidLoad()

        setLayout()
        configureUI()
        bindNotification()
        bind()
    }

    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return isDarkContentBackground ? .lightContent : .default
    }

    public static func viewController(
        bottomTabBarComponent: BottomTabBarComponent,
        mainTabBarComponent: MainTabBarComponent,
        playerComponent: PlayerComponent,
        playlistFactory: PlaylistFactory,
        playlistPresenterGlobalState: PlayListPresenterGlobalStateProtocol
    ) -> MainContainerViewController {
        let viewController = MainContainerViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)

        viewController.bottomTabBarComponent = bottomTabBarComponent
        viewController.mainTabBarComponent = mainTabBarComponent
        viewController.playerComponent = playerComponent
        viewController.playlistFactory = playlistFactory
        viewController.playlistPresenterGlobalState = playlistPresenterGlobalState

        return viewController
    }
}

extension MainContainerViewController {
    @objc
    func panGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        let point = gestureRecognizer.location(in: self.view)
        let direction = gestureRecognizer.direction(in: self.view)
//        let velocity = gestureRecognizer.velocity(in: self.view)

        let window: UIWindow? = UIApplication.shared.windows.first
        let safeAreaInsetsTop: CGFloat = window?.safeAreaInsets.top ?? 0
        let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
        var statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        if safeAreaInsetsTop > statusBarHeight {
            statusBarHeight = safeAreaInsetsTop
        }

        let screenHeight = APP_HEIGHT() - safeAreaInsetsBottom
        var centerRatio = (-panelViewTopConstraint.constant + originalPanelPosition) /
            (screenHeight + originalPanelPosition)

        switch gestureRecognizer.state {
        case .began:
            return

        case .changed:
            let yDelta = point.y - lastPoint.y

            var newConstant = panelViewTopConstraint.constant + yDelta
            newConstant = newConstant > originalPanelPosition ? originalPanelPosition : newConstant
            newConstant = newConstant < -screenHeight ? -screenHeight : newConstant

            self.panelViewTopConstraint.constant = newConstant
            self.bottomContainerViewBottomConstraint.constant = centerRatio * -self.originalTabBarPosition

        case .ended:
            let standard: CGFloat = direction.contains(.Down) ? 1.0 : direction.contains(.Up) ? 0.0 : 0.5

            // 플레이어 확장 여부
            let expanded: Bool = (centerRatio < standard) ? false : true

            self.panelViewTopConstraint.constant = expanded ? -screenHeight : self.originalPanelPosition
            self.bottomContainerView.isHidden = expanded ? true : false

            UIView.animate(
                withDuration: 0.35,
                delay: 0.0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0.8,
                options: [.curveEaseInOut],
                animations: {
                    self.bottomContainerViewBottomConstraint.constant = expanded ? -self.originalTabBarPosition : 0
                    self.view.layoutIfNeeded()

                },
                completion: { _ in
                }
            )

            centerRatio = (-panelViewTopConstraint.constant + originalPanelPosition) /
                (screenHeight + originalPanelPosition)

        default:
            return
        }

        self.lastPoint = point
    }

    private func setLayout() {
        view.addSubview(playlistFloatingActionButton)

        playlistFloatingActionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomContainerView.snp.top).offset(-20)
            $0.size.equalTo(56)
        }
    }

    private func configureUI() {
        // Main Content
        let viewController = mainTabBarComponent.makeView().wrapNavigationController
        self.addChild(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(containerView)
        }

        // Bottom TabBar
        let bottomTabBar = bottomTabBarComponent.makeView()
        self.addChild(bottomTabBar)
        self.bottomContainerView.addSubview(bottomTabBar.view)

        bottomTabBar.didMove(toParent: self)
        bottomTabBar.delegate = self
        bottomTabBar.view.snp.makeConstraints {
            $0.edges.equalTo(bottomContainerView)
        }

        // Base UI
        _ = panGestureRecognizer

        self.originalTabBarPosition = self.bottomContainerViewHeight.constant // 56
        self.originalPanelPosition = self.panelViewTopConstraint.constant // -56
        self.originalPanelAlpha = self.panelView.alpha

        self.panelView.isHidden = false
        self.panelView.backgroundColor = .clear

        self.safeAreaBottomView.backgroundColor = UIColor.white
        self.safeAreaBottomViewHeightConstraint.constant = SAFEAREA_BOTTOM_HEIGHT()
        self.view.layoutIfNeeded()
    }
}

extension MainContainerViewController: BottomTabBarViewDelegate {
    func handleTapped(index previous: Int, current: Int) {
        guard let navigationController = self.children.first as? UINavigationController,
              let mainTabBarViewController = navigationController.viewControllers.first as? MainTabBarViewController
        else { return }
        mainTabBarViewController.updateContent(previous: previous, current: current)
    }

    func equalHandleTapped(index current: Int) {
        guard let navigationController = self.children.first as? UINavigationController,
              let mainTabBarViewController = navigationController.viewControllers.first as? MainTabBarViewController
        else { return }
        mainTabBarViewController.equalHandleTapped(for: current)
    }
}

extension MainContainerViewController {
    private func bind() {
        let playlistButtonAction = UIAction { [navigationController, playlistFactory]  _ in
            guard let playlistFactory else { return }
            let playlistViewController = playlistFactory.makeViewController()
            playlistViewController.modalPresentationStyle = .overFullScreen
            navigationController?.topViewController?.present(playlistViewController, animated: true)
        }
        playlistFloatingActionButton.addAction(
            playlistButtonAction,
            for: .primaryActionTriggered
        )

        playlistPresenterGlobalState.presentPlayListObservable
            .bind { [navigationController, playlistFactory] _ in
                guard let playlistFactory else { return }
                let playlistViewController = playlistFactory.makeViewController()
                playlistViewController.modalPresentationStyle = .overFullScreen
                navigationController?.topViewController?.present(playlistViewController, animated: true)
            }
            .disposed(by: disposeBag)
    }

    private func bindNotification() {
        NotificationCenter.default.rx
            .notification(.statusBarEnterDarkBackground)
            .subscribe(onNext: { [weak self] _ in
                self?.statusBarEnterDarkBackground()
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.statusBarEnterLightBackground)
            .subscribe(onNext: { [weak self] _ in
                self?.statusBarEnterLightBackground()
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.showSongCart)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2) {
                    self.panelView.alpha = 0
                }
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.hideSongCart)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2) {
                    self.panelView.alpha = 1
                }
            }).disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(UIApplication.didBecomeActiveNotification)
            .subscribe(onNext: { _ in
                PlayState.shared.checkForPlayerState { state in
                    switch state {
                    case .idle:
                        DEBUG_LOG("🚀:: Player State ➡️ [idle]")
                    case .ready:
                        DEBUG_LOG("🚀:: Player State ➡️ [ready]")
                    case let .error(error):
                        DEBUG_LOG("🚀:: Player State ➡️ [error] \(error.localizedDescription)")
                        PlayState.shared.resetPlayer()
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MainContainerViewController {
    private func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        UIView.animate(withDuration: 0.15) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    private func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        UIView.animate(withDuration: 0.15) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
