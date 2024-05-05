import UIKit

public protocol TextPopUpFactory {
    func makeView(
        text: String?,
        cancelButtonIsHidden: Bool,
        allowsDragAndTapToDismiss: Bool?,
        confirmButtonText: String?,
        cancelButtonText: String?,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController
}
