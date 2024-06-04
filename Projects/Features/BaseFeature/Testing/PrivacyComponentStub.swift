import BaseFeatureInterface
import BaseFeature
import UIKit
 
public final class PrivacyComponentStub: PrivacyFactory {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .privacy)
    }
}
