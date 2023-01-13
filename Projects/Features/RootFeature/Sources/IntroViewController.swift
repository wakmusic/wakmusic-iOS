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
        
        let animationView = LottieAnimationView(name: "Splash_Logo_Main", bundle: DesignSystemResources.bundle)
        animationView.frame = self.logoContentView.bounds
        animationView.backgroundColor = .clear
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .playOnce

        self.logoContentView.addSubview(animationView)
        animationView.play()
    }
}
