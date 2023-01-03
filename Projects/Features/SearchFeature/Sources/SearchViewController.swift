import UIKit
import Utility
import DesignSystem

public final class SearchViewController: UIViewController, ViewControllerFromStoryBoard {

    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    public static func viewController() -> SearchViewController {
        let viewController = SearchViewController.viewController(storyBoardName: "Search", bundle: Bundle.module)
        return viewController
    }
}
