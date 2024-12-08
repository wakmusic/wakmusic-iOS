import ArtistFeature
import BaseFeature
import Combine
import DesignSystem
import LogManager
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
    private var subscription = Set<AnyCancellable>()

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

        let startPage: Int = PreferenceManager.shared.startPage ?? 0
        let bottomOffset: CGFloat = startPage == 3 ?
            PlaylistFloatingButtonPosition.top.bottomOffset :
            PlaylistFloatingButtonPosition.default.bottomOffset
        playlistFloatingActionButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(bottomContainerView.snp.top).offset(bottomOffset)
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
            LogManager.analytics(MainTabAnalyticsLog.clickPlaylistFabButton)
            guard let playlistFactory else { return }
            let playlistViewController = playlistFactory.makeViewController()
            playlistViewController.modalPresentationStyle = .overFullScreen
            navigationController?.topViewController?.present(playlistViewController, animated: true)
        }
        playlistFloatingActionButton.isHidden = PlayState.shared.isEmpty
        playlistFloatingActionButton.addAction(
            playlistButtonAction,
            for: .primaryActionTriggered
        )

        playlistPresenterGlobalState.presentPlayListObservable
            .bind { [navigationController, playlistFactory] currentSongID in
                guard let playlistFactory else { return }
                let playlistViewController = if let currentSongID {
                    playlistFactory.makeViewController(currentSongID: currentSongID)
                } else {
                    playlistFactory.makeViewController()
                }
                playlistViewController.modalPresentationStyle = .overFullScreen
                navigationController?.topViewController?.present(playlistViewController, animated: true)
            }
            .disposed(by: disposeBag)

        PlayState.shared.listChangedPublisher
            .map(\.isEmpty)
            .assign(to: \.isHidden, on: playlistFloatingActionButton)
            .store(in: &subscription)
    }

    func bindNotification() {
        NotificationCenter.default.rx
            .notification(.willStatusBarEnterDarkBackground)
            .subscribe(onNext: { [weak self] _ in
                self?.statusBarEnterDarkBackground()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.willStatusBarEnterLightBackground)
            .subscribe(onNext: { [weak self] _ in
                self?.statusBarEnterLightBackground()
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.shouldHidePlaylistFloatingButton)
            .subscribe(onNext: { [playlistFloatingActionButton] _ in
                UIView.animate(withDuration: 0.2) {
                    playlistFloatingActionButton.alpha = 0
                }
            })
            .disposed(by: disposeBag)

        NotificationCenter.default.rx
            .notification(.shouldShowPlaylistFloatingButton)
            .subscribe(onNext: { [playlistFloatingActionButton] _ in
                UIView.animate(withDuration: 0.2) {
                    playlistFloatingActionButton.alpha = 1
                }
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(
            PreferenceManager.shared.$startPage.map { $0 ?? 0 },
            NotificationCenter.default.rx
                .notification(.shouldMovePlaylistFloatingButton)
                .map { $0.object as? PlaylistFloatingButtonPosition ?? .default }
        ) { startPage, pos -> (Int, PlaylistFloatingButtonPosition) in
            return (startPage, pos)
        }
        .bind(with: self, onNext: { owner, params in
            let (startPage, pos) = params
            var bottomOffset: CGFloat
            switch startPage {
            case 3:
                bottomOffset = pos.bottomOffset
            default:
                bottomOffset = PlaylistFloatingButtonPosition.default.bottomOffset
            }
            owner.playlistFloatingActionButton.snp.updateConstraints {
                $0.trailing.equalToSuperview().inset(20)
                $0.bottom.equalTo(owner.bottomContainerView.snp.top).offset(bottomOffset)
                $0.size.equalTo(56)
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
