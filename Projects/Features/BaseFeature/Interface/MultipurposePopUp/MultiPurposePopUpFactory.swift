// This is for Tuist

import UIKit

public protocol MultiPurposePopUpFactory {
    func makeView(type: PurposeType,
                  key: String,
                  completion: ((String) -> Void)?) -> UIViewController
}
