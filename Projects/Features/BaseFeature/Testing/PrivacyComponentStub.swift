@testable import BaseFeature
import BaseFeatureInterface
import UIKit

public final class PrivacyComponentStub: PrivacyFactory {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .privacy)
    }
}
