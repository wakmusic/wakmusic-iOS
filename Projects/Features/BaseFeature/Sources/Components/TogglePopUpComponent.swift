import BaseFeatureInterface
import NeedleFoundation
import UIKit

public final class TogglePopUpComponent: Component<EmptyDependency>, TogglePopUpFactory {
    public func makeView(
        titleString: String,
        firstItemString: String,
        secondItemString: String,
        cancelButtonText: String = "취소",
        confirmButtonText: String = "확인",
        descriptionText: String = "",
        completion: (() -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        return TogglePopupViewController(
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
