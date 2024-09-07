import BaseFeatureInterface
import NeedleFoundation
import UIKit

public protocol PrivacyDependency: Dependency {}

public final class PrivacyComponent: Component<PrivacyDependency>, PrivacyFactory {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .privacy)
    }
}
