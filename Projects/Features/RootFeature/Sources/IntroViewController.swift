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

        // Intro 화면에서는 앱에 대한 기본 정보를 받아오는 일을 보통 하는데, 없어서 딜레이 조금 주고 뭔가 하는척 해봤습니다.
        self.perform(#selector(self.showTabBar), with: nil, afterDelay: 1.7)
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
        animationView.contentMode = .scaleToFill
        animationView.loopMode = .playOnce
        self.logoContentView.addSubview(animationView)
        animationView.play()
    }
}
