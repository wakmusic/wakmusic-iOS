import UIKit
import Utility
import DesignSystem
import BaseFeature
import PlayerFeature
import SnapKit
import RxSwift
import DomainModule
import CommonFeature

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
    
    var originalPanelAlpha: CGFloat = 0
    var originalPanelPosition: CGFloat = 0
    var lastPoint: CGPoint = .zero
    var originalTabBarPosition: CGFloat = 0

    var bottomTabBarComponent: BottomTabBarComponent!
    var mainTabBarComponent: MainTabBarComponent!
    var playerComponent: PlayerComponent!

    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self,
                                             action: #selector(panGesture(_:)))
        self.panelView.addGestureRecognizer(gesture)
        return gesture
    }()
    var isDarkContentBackground: Bool = false
    var playerMode: PlayerMode = .mini
    var disposeBag = DisposeBag()
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configurePlayer()
        updatePlayerMode(with: self.playerMode, animate: false)
        bindNotification()
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return isDarkContentBackground ? .lightContent : .default
    }

    public static func viewController(
        bottomTabBarComponent: BottomTabBarComponent,
        mainTabBarComponent: MainTabBarComponent,
        playerComponent: PlayerComponent
    ) -> MainContainerViewController {
        let viewController = MainContainerViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)

        viewController.bottomTabBarComponent = bottomTabBarComponent
        viewController.mainTabBarComponent = mainTabBarComponent
        viewController.playerComponent = playerComponent

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

            updatePlayerViewController(value: Float(centerRatio))
            
        case .ended:
            let standard: CGFloat = direction.contains(.Down) ? 1.0 : direction.contains(.Up) ? 0.0 : 0.5
            
            //플레이어 확장 여부
            let expanded: Bool = (centerRatio < standard) ? false : true
            
            self.panelViewTopConstraint.constant = (expanded) ? -screenHeight : self.originalPanelPosition
            self.bottomContainerView.isHidden = (expanded) ? true : false

            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: [.curveEaseInOut],
                           animations: {

                self.bottomContainerViewBottomConstraint.constant = (expanded) ? -self.originalTabBarPosition : 0
                self.view.layoutIfNeeded()

            }, completion: { _ in
                
            })
            
            centerRatio = (-panelViewTopConstraint.constant + originalPanelPosition) / (screenHeight + originalPanelPosition)
            updatePlayerViewController(value: Float(centerRatio))

        default:
            return
        }

        self.lastPoint = point
    }
    
    private func updatePlayerViewController(value: Float) {
        if let playerViewController: PlayerViewController = self.children.last as? PlayerViewController {
            playerViewController.updateOpacity(value: value)
        }
    }
    
    private func configureUI() {

        //Main Content
        let viewController = mainTabBarComponent.makeView().wrapNavigationController
        self.addChild(viewController)
        self.containerView.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        viewController.view.snp.makeConstraints {
            $0.edges.equalTo(containerView)
        }
        
        //Bottom TabBar
        let bottomTabBar = bottomTabBarComponent.makeView()
        self.addChild(bottomTabBar)
        self.bottomContainerView.addSubview(bottomTabBar.view)
        
        bottomTabBar.didMove(toParent: self)
        bottomTabBar.delegate = self
        bottomTabBar.view.snp.makeConstraints {
            $0.edges.equalTo(bottomContainerView)
        }

        //Base UI
        _ = panGestureRecognizer

        self.originalTabBarPosition = self.bottomContainerViewHeight.constant //56
        self.originalPanelPosition = self.panelViewTopConstraint.constant // -56
        self.originalPanelAlpha = self.panelView.alpha
        
        self.panelView.isHidden = false
        self.panelView.backgroundColor = .clear
        
        self.safeAreaBottomView.backgroundColor = UIColor.white
        self.safeAreaBottomViewHeightConstraint.constant = SAFEAREA_BOTTOM_HEIGHT()
        self.view.layoutIfNeeded()
    }
    
    private func configurePlayer() {
        let vc = playerComponent.makeView()
        self.addChild(vc)
        panelView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.snp.makeConstraints {
            $0.edges.equalTo(panelView)
        }
        
        //미니 플레이어 상태
        updatePlayerViewController(value: Float(0))
    }
}

extension MainContainerViewController: BottomTabBarViewDelegate {
    func handleTapped(index previous: Int, current: Int) {
        guard let navigationController = self.children.first as? UINavigationController,
              let mainTabBarViewController = navigationController.viewControllers.first as? MainTabBarViewController else { return }
        
        mainTabBarViewController.updateContent(previous: previous, current: current)
    }
}

public extension MainContainerViewController {
    
    func updatePlayerMode(with mode: PlayerMode, animate: Bool) {
        switch mode {
        case .full, .mini:
            expandPlayer(expanded: mode == .full, animate: animate)
        case .close:
            closePlayer(animate: animate)
        }
    }
    
    // 플레이어 확장, 축소
    private func expandPlayer(expanded: Bool, animate: Bool) {
        let screenHeight = APP_HEIGHT() - SAFEAREA_BOTTOM_HEIGHT()
        self.panelViewTopConstraint.constant = expanded ? -screenHeight : self.originalPanelPosition
        self.bottomContainerView.isHidden = expanded ? true : false

        UIView.animate(withDuration: animate ? 0.5 : 0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {

            self.bottomContainerViewBottomConstraint.constant = expanded ? -self.originalTabBarPosition : 0
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
        })
        
        updatePlayerViewController(value: expanded ? Float(1) : Float(0))
    }
    
    // 플레이어 닫기
    private func closePlayer(animate: Bool) {
        UIView.animate(withDuration: animate ? 0.5 : 0,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {
            
            self.panelViewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
            
        }, completion: { _ in
        })
    }
    
    // 플레이어 생성 (현재 미사용, 추후에는 쓸지도..?)
    private func makePlayer(songs: [SongEntity], expanded: Bool = false) {
        let vc = playerComponent.makeView()
        self.addChild(vc)
        panelView.addSubview(vc.view)
        vc.didMove(toParent: self)
        panelView.isHidden = false

        vc.view.snp.makeConstraints {
            $0.edges.equalTo(panelView)
        }

        let screenHeight = APP_HEIGHT() - SAFEAREA_BOTTOM_HEIGHT()
        self.panelViewTopConstraint.constant = expanded ? -screenHeight : self.originalPanelPosition
        self.bottomContainerView.isHidden = expanded ? true : false

        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {

            self.bottomContainerViewBottomConstraint.constant = expanded ? -self.originalTabBarPosition : 0
            self.view.layoutIfNeeded()

        }, completion: { _ in
        })
        
        //미니플레이어 상태는 0, 풀스크린이면 1
        updatePlayerViewController(value: expanded ? Float(1) : Float(0))
    }
    
    // 플레이어 삭제 (현재 미사용, 추후에는 쓸지도..?)
    private func removePlayer() {
        guard let playerViewController = self.children.last as? PlayerViewController else {
            DEBUG_LOG("❌ Player Load Failed")
            return
        }
        
        playerViewController.willMove(toParent: nil)
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
        
        self.panelView.subviews.forEach { $0.removeFromSuperview() }
        self.panelView.isHidden = true
        DEBUG_LOG("❌ Player Closed")
    }
}

extension MainContainerViewController {
    private func bindNotification() {
        NotificationCenter.default.rx
            .notification(.updatePlayerMode)
            .subscribe(onNext: { [weak self] (notification) in
                guard let mode = notification.object as? PlayerMode else { return }
                self?.playerMode = mode
                self?.updatePlayerMode(with: mode, animate: true)
            }).disposed(by: disposeBag)
        
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
