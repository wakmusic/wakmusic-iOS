@testable import BaseFeature
import BaseFeatureInterface
import UIKit

public final class TextPopupComponentStub: TextPopupFactory, @unchecked Sendable {
    public func makeView(
        text: String?,
        cancelButtonIsHidden: Bool,
        confirmButtonText: String?,
        cancelButtonText: String?,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController {
        return TextPopupViewController.viewController(
            text: text ?? "",
            cancelButtonIsHidden: cancelButtonIsHidden,
            confirmButtonText: confirmButtonText ?? "확인",
            cancelButtonText: cancelButtonText ?? "취소",
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
