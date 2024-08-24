import UIKit

public protocol TogglePopupFactory {
    func makeView(
        titleString: String,
        firstItemString: String,
        secondItemString: String,
        cancelButtonText: String,
        confirmButtonText: String,
        descriptionText: String,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController
}

public extension TogglePopupFactory {
    func makeView(
        titleString: String,
        firstItemString: String,
        secondItemString: String,
        cancelButtonText: String = "취소",
        confirmButtonText: String = "확인",
        descriptionText: String = "",
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        self.makeView(
            titleString: titleString,
            firstItemString: firstItemString,
            secondItemString: secondItemString,
            cancelButtonText: cancelButtonText,
            confirmButtonText: confirmButtonText,
            descriptionText: descriptionText,
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
