import UIKit
import Utility
import DesignSystem

public final class StorageViewController: UIViewController, ViewControllerFromStoryBoard {

    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    public static func viewController() -> StorageViewController {
        let viewController = StorageViewController.viewController(storyBoardName: "Storage", bundle: Bundle.module)
        return viewController
    }
}
