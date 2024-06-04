import BaseFeature
import BaseFeatureInterface
import UIKit

public final class PrivacyComponentStub: PrivacyFactoryStub {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .privacy)
    }
}
