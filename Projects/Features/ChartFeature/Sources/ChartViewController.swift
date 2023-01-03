import UIKit
import Utility
import DesignSystem

public final class ChartViewController: UIViewController, ViewControllerFromStoryBoard {

    public override func viewDidLoad() {
        super.viewDidLoad()
    }

    public static func viewController() -> ChartViewController {
        let viewController = ChartViewController.viewController(storyBoardName: "Chart", bundle: Bundle.module)
        return viewController
    }
}
