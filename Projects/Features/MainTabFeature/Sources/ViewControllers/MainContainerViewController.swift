import ArtistFeature
import BaseFeature
import DesignSystem
import PlaylistFeatureInterface
import RxSwift
import SnapKit
import SongsDomainInterface
import UIKit
import Utility

open class MainContainerViewController: BaseViewController, ViewControllerFromStoryBoard {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomContainerView: UIView!
    private let playlistFloatingActionButton = PlayListFloatingActionButton()

    var bottomTabBarComponent: BottomTabBarComponent!
    var mainTabBarComponent: MainTabBarComponent!
    var playlistFactory: PlaylistFactory!
    var playlistPresenterGlobalState: PlayListPresenterGlobalStateProtocol!

    var isDarkContentBackground: Bool = false
    private let disposeBag = DisposeBag()

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
        playlistFactory: PlaylistFactory,
        playlistPresenterGlobalState: PlayListPresenterGlobalStateProtocol
    ) -> MainContainerViewController {
        let viewController = MainContainerViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
        viewController.bottomTabBarComponent = bottomTabBarComponent
        viewController.mainTabBarComponent = mainTabBarComponent
        viewController.playlistFactory = playlistFactory
        viewController.playlistPresenterGlobalState = playlistPresenterGlobalState
        return viewController
    }
}

private extension MainContainerViewController {
    func setLayout() {
        view.addSubview(playlistFloatingActionButton)

        let startPage: Int = Utility.PreferenceManager.startPage ?? 0

        playlistFloatingActionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomContainerView.snp.top).offset(startPage == 3 ? -80 : -20)
            $0.size.equalTo(56)
        }
    }

    func configureUI() {
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

private extension MainContainerViewController {
    func bind() {
        let playlistButtonAction = UIAction { [navigationController, playlistFactory] _ in
            guard let playlistFactory else { return }
            let playlistViewController = playlistFactory.makeViewController()
            navigationController?.topViewController?.showBottomSheet(
                content: playlistViewController,
                size: .fixed(APP_HEIGHT())
            )
        }
        playlistFloatingActionButton.addAction(
            playlistButtonAction,
            for: .primaryActionTriggered
        )

        playlistPresenterGlobalState.presentPlayListObservable
            .bind { [navigationController, playlistFactory] _ in
                guard let playlistFactory else { return }
                let playlistViewController = playlistFactory.makeViewController()
                navigationController?.topViewController?.showBottomSheet(
                    content: playlistViewController,
                    size: .fixed(APP_HEIGHT())
                )
            }
            .disposed(by: disposeBag)

        Utility.PreferenceManager.$startPage
            .skip(1)
            .compactMap { $0 }
            .bind(with: self) { owner, page in
                owner.playlistFloatingActionButton.snp.remakeConstraints {
                    $0.trailing.equalToSuperview().inset(20)
                    $0.bottom.equalTo(owner.bottomContainerView.snp.top).offset(page == 3 ? -80 : -20)
                    $0.size.equalTo(56)
                }
            }
            .disposed(by: disposeBag)
    }

    func bindNotification() {
        NotificationCenter.default.rx
            .notification(.statusBarEnterDarkBackground)
            .subscribe(onNext: { [weak self] _ in
                self?.statusBarEnterDarkBackground()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.statusBarEnterLightBackground)
            .subscribe(onNext: { [weak self] _ in
                self?.statusBarEnterLightBackground()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.showSongCart)
            .subscribe(onNext: { [playlistFloatingActionButton] _ in
                UIView.animate(withDuration: 0.2) {
                    playlistFloatingActionButton.alpha = 0
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.hideSongCart)
            .subscribe(onNext: { [playlistFloatingActionButton] _ in
                UIView.animate(withDuration: 0.2) {
                    playlistFloatingActionButton.alpha = 1
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension MainContainerViewController {
    func statusBarEnterLightBackground() {
        isDarkContentBackground = false
        UIView.animate(withDuration: 0.15) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }

    func statusBarEnterDarkBackground() {
        isDarkContentBackground = true
        UIView.animate(withDuration: 0.15) {
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
}
