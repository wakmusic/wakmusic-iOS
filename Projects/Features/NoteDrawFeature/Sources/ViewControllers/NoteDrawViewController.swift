import UIKit
import DesignSystem
import LogManager
import Utility

class NoteDrawViewController: UIViewController {

    deinit {
        LogManager.printDebug("❌:: \(Self.self) deinit")
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("\(Self.self) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
