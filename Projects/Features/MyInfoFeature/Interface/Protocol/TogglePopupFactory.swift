import UIKit

public protocol TogglePopupFactory {
    func makeView(
        titleString: String,
        firstItemString: String,
        secondItemString: String,
        cancelButtonText: String,
        confirmButtonText: String,
        firstDescriptionText: String,
        secondDescriptionText: String,
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
        firstDescriptionText: String = "",
        secondDescriptionText: String = "",
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        self.makeView(
            titleString: titleString,
            firstItemString: firstItemString,
            secondItemString: secondItemString,
            cancelButtonText: cancelButtonText,
            confirmButtonText: confirmButtonText,
            firstDescriptionText: firstDescriptionText,
            secondDescriptionText: secondDescriptionText,
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
