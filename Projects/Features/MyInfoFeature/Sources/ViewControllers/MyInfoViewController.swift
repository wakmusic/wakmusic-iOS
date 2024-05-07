import BaseFeature
import UIKit

/// TODO:
public final class MyInfoViewController: UIViewController, EqualHandleTappedType {

    override public func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .red
    }
}

public extension MyInfoViewController {
    func equalHandleTapped() {
    }
}
