import UIKit
import Utility
import DesignSystem
import PanModal

public final class HomeViewController: UIViewController, ViewControllerFromStoryBoard {

    @IBOutlet weak var gradationImageView: UIImageView! {
        didSet {
            gradationImageView.image = DesignSystemAsset.Home.gradationBg.image
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        DEBUG_LOG("\(Self.self) viewDidLoad")
    }

    public static func viewController() -> HomeViewController {
        let viewController = HomeViewController.viewController(storyBoardName: "Home", bundle: Bundle.module)
        return viewController
    }

    @IBAction func buttonAction(_ sender: Any) {
        let textPopupViewController = TextPopupViewController.viewController(
            text: "한 줄\n두 줄",
            cancelButtonIsHidden: false
        )
        let viewController: PanModalPresentable.LayoutType = textPopupViewController
        self.presentPanModal(viewController)
    }
}
