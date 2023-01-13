import UIKit
import Utility
import DesignSystem
import PlayerFeature
import SnapKit

open class MainContainerViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var tabBarCoverView: UIView!
    @IBOutlet weak var tabBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var panelViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var panelViewHeightConstraint: NSLayoutConstraint!

    var originalPanelAlpha: CGFloat = 0
    var originalPanelPosition: CGFloat = 0
    var lastPoint: CGPoint = .zero
    var originalTabBarPosition: CGFloat = 0

    lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self,
                                             action: #selector(panGesture(_:)))
        self.panelView.addGestureRecognizer(gesture)
        return gesture
    }()

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configurePlayer()
    }

    public static func viewController() -> MainContainerViewController {
        let viewController = MainContainerViewController.viewController(storyBoardName: "Main", bundle: Bundle.module)
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
            updatePlayerViewController(value: Float(centerRatio))
            updateMainTabViewController(value: centerRatio)
            
        case .ended:
            let standard: CGFloat = direction.contains(.Down) ? 1.0 : direction.contains(.Up) ? 0.0 : 0.5
            self.panelViewTopConstraint.constant = (centerRatio < standard) ? self.originalPanelPosition : -screenHeight

            UIView.animate(withDuration: 0.35,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.8,
                           options: [.curveEaseInOut],
                           animations: {

                self.tabBarHeightConstraint.constant = (centerRatio < standard) ? self.originalTabBarPosition : 0
                self.view.layoutIfNeeded()

            }, completion: { _ in
                self.tabBarCoverView.isHidden = (centerRatio < standard) ? true : false
            })
            
            centerRatio = (-panelViewTopConstraint.constant + originalPanelPosition) / (screenHeight + originalPanelPosition)
            updatePlayerViewController(value: Float(centerRatio))
            updateMainTabViewController(value: centerRatio)

        default:
            return
        }

        self.lastPoint = point
    }
    
    private func updateMainTabViewController(value: CGFloat) {
        if let mainTabBarViewController: MainTabBarViewController = self.children.first as? MainTabBarViewController {
            mainTabBarViewController.updateLayout(value: value)
        }
    }
    
    private func updatePlayerViewController(value: Float) {
        if let playerViewController: PlayerViewController = self.children.last as? PlayerViewController {
            playerViewController.updateOpacity(value: value)
        }
    }
    
    private func configureUI() {

        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarCoverView.isHidden = true

        let viewController = MainTabBarViewController.viewController()
        self.addChild(viewController)
        viewController.didMove(toParent: self)

        _ = panGestureRecognizer

        self.originalTabBarPosition = self.tabBarHeightConstraint.constant // 56
        self.originalPanelPosition = self.panelViewTopConstraint.constant // -56
        self.originalPanelAlpha = self.panelView.alpha
        self.panelView.isHidden = false
        self.panelView.backgroundColor = .white
        self.view.layoutIfNeeded()
    }
    
    private func configurePlayer() {
        let vc = PlayerViewController()
        self.addChild(vc)
        panelView.addSubview(vc.view)
        vc.didMove(toParent: self)
        
        vc.view.snp.makeConstraints {
            $0.edges.equalTo(panelView)
        }
        updatePlayerViewController(value: Float(0))

        /*
        let window: UIWindow? = UIApplication.shared.windows.first
        let safeAreaInsetsTop: CGFloat = window?.safeAreaInsets.top ?? 0
        let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0
        var statusBarHeight: CGFloat = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        if safeAreaInsetsTop > statusBarHeight {
            statusBarHeight = safeAreaInsetsTop
        }

        let screenHeight = APP_HEIGHT() - safeAreaInsetsBottom
        
        self.panelViewTopConstraint.constant = -screenHeight

        UIView.animate(withDuration: 0.35,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {

            self.tabBarHeightConstraint.constant = 0
            self.view.layoutIfNeeded()

        }, completion: { _ in
            self.tabBarCoverView.isHidden = false
        })
         */
    }
}

public extension MainContainerViewController {
    
    //expanded: 플레이어 확장/축소 여부
    func updatePlayerView(expanded: Bool) {
        
        let window: UIWindow? = UIApplication.shared.windows.first
        let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0

        let screenHeight = APP_HEIGHT() - safeAreaInsetsBottom
        self.panelViewTopConstraint.constant = (expanded) ? -screenHeight : self.originalPanelPosition

        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {

            self.tabBarHeightConstraint.constant = (expanded) ? 0 : self.originalTabBarPosition
            self.view.layoutIfNeeded()

        }, completion: { _ in
            self.tabBarCoverView.isHidden = (expanded) ? false : true
        })
        
        updatePlayerViewController(value: (expanded) ? Float(1) : Float(0))
        updateMainTabViewController(value: (expanded) ? 1 : 0)
    }
    
    //플레이어 열기
    func openPlayer() {
        
        let vc = PlayerViewController()
        self.addChild(vc)
        panelView.addSubview(vc.view)
        vc.didMove(toParent: self)
        panelView.isHidden = false

        vc.view.snp.makeConstraints {
            $0.edges.equalTo(panelView)
        }

        let window: UIWindow? = UIApplication.shared.windows.first
        let safeAreaInsetsBottom: CGFloat = window?.safeAreaInsets.bottom ?? 0

        let screenHeight = APP_HEIGHT() - safeAreaInsetsBottom
        self.panelViewTopConstraint.constant = -screenHeight

        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0.8,
                       options: [.curveEaseInOut],
                       animations: {

            self.tabBarHeightConstraint.constant = 0
            self.view.layoutIfNeeded()

        }, completion: { _ in
            self.tabBarCoverView.isHidden = false
        })
        
        updatePlayerViewController(value: Float(1))
        updateMainTabViewController(value: 1)
    }
    
    //플레이어 닫기
    func closePlayer() {
        
        self.panelView.subviews.forEach { $0.removeFromSuperview() }
        self.panelView.isHidden = true
        
        guard let playerViewController = self.children.last as? PlayerViewController else { return }
        
        playerViewController.willMove(toParent: nil)
        playerViewController.view.removeFromSuperview()
        playerViewController.removeFromParent()
    }
}
