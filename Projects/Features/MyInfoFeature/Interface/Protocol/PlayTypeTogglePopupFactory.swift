import UIKit

public protocol PlayTypeTogglePopupFactory {
    func makeView(
        completion: ((_ selectedItemString: String) -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController
}

public extension PlayTypeTogglePopupFactory {
    func makeView(
        completion: ((_ selectedItemString: String) -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        self.makeView(
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
