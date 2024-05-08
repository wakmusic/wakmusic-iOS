import BaseFeature
import UIKit

/// TODO:
class MyInfoViewController: UIViewController, EqualHandleTappedType {
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .red
    }
}

extension MyInfoViewController {
    func equalHandleTapped() {}
}
