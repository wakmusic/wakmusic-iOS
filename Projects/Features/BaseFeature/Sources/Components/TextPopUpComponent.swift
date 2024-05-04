import BaseFeatureInterface
import NeedleFoundation
import UIKit

public final class TextPopUpComponent: Component<EmptyDependency>, TextPopUpFactory {
    public func makeView(
        text: String?,
        cancelButtonIsHidden: Bool,
        allowsDragAndTapToDismiss: Bool?,
        confirmButtonText: String?,
        cancelButtonText: String?,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController {
        return TextPopupViewController.viewController(
            text: text ?? "",
            cancelButtonIsHidden: cancelButtonIsHidden,
            allowsDragAndTapToDismiss: allowsDragAndTapToDismiss ?? true,
            confirmButtonText: confirmButtonText ?? "확인",
            cancelButtonText: cancelButtonText ?? "취소",
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}