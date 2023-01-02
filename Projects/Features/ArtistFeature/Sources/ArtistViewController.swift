import UIKit
import Utility
import DesignSystem
import PanModal

public final class ArtistViewController: UIViewController, ViewControllerFromStoryBoard {

    public override func viewDidLoad() {
        super.viewDidLoad()

    }

    public static func viewController() -> ArtistViewController {
        let viewController = ArtistViewController.viewController(storyBoardName: "Artist", bundle: Bundle.module)
        return viewController
    }
}
