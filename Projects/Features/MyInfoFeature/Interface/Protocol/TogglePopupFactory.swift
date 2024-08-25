import UIKit

public protocol TogglePopupFactory {
    func makeView(
        completion: ((_ selectedItemString: String) -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController
}

public extension TogglePopupFactory {
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
