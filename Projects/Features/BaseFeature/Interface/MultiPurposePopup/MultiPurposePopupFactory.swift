import UIKit

@MainActor
public protocol MultiPurposePopupFactory {
    func makeView(
        type: PurposeType,
        key: String,
        completion: ((String) -> Void)?
    ) -> UIViewController
}
