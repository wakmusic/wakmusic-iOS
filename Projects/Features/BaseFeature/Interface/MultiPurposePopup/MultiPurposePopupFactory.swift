import UIKit

public protocol MultiPurposePopupFactory {
    func makeView(
        type: PurposeType,
        key: String,
        completion: ((String) -> Void)?
    ) -> UIViewController
}
