@testable import BaseFeature
import BaseFeatureInterface
import UIKit

public final class PrivacyComponentStub: PrivacyFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .privacy)
    }
}
