import UIKit

@MainActor
public protocol TextPopupFactory {
    func makeView(
        text: String?,
        cancelButtonIsHidden: Bool,
        confirmButtonText: String?,
        cancelButtonText: String?,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController
}

public extension TextPopupFactory {
    func makeView(
        text: String? = nil,
        cancelButtonIsHidden: Bool = false,
        confirmButtonText: String? = nil,
        cancelButtonText: String? = nil,
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        self.makeView(
            text: text,
            cancelButtonIsHidden: cancelButtonIsHidden,
            confirmButtonText: confirmButtonText,
            cancelButtonText: cancelButtonText,
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
