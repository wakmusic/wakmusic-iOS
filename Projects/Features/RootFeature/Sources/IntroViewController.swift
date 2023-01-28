import UIKit
import Utility
import DesignSystem
import MainTabFeature
import Lottie

open class IntroViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var logoContentView: UIView!

    open override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        self.perform(#selector(self.showTabBar), with: nil, afterDelay: 1.6)
    }

    public static func viewController() -> IntroViewController {
        let viewController = IntroViewController.viewController(storyBoardName: "Intro", bundle: Bundle.module)
        return viewController
    }
}

extension IntroViewController {

    @objc
    private func showTabBar() {
        let viewController = MainContainerViewController.viewController()
        self.navigationController?.pushViewController(viewController, animated: false)
    }

    private func configureUI() {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        let animationView = LottieAnimationView(name: "Splash_Logo_Main", bundle: DesignSystemResources.bundle)
        animationView.frame = self.logoContentView.bounds
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .playOnce

        self.logoContentView.addSubview(animationView)
        
        let originWidth: CGFloat = 156.0
        let originHeight: CGFloat = 160.0
        let rate: CGFloat = originHeight/max(1.0, originWidth)

        let width: CGFloat = (156.0 * APP_WIDTH()) / 375.0
        let height: CGFloat = width * rate

        animationView.snp.makeConstraints {
            $0.width.equalTo(width)
            $0.height.equalTo(height)
            $0.centerX.equalTo(self.logoContentView.snp.centerX)
            $0.centerY.equalTo(self.logoContentView.snp.centerY)
        }
        animationView.play()
    }
}
