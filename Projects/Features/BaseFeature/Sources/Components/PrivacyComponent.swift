import BaseFeatureInterface
import NeedleFoundation
import UIKit

public protocol PrivacyDependency: Dependency {}

public final class PrivacyComponent: Component<PrivacyDependency> {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .privacy)
    }
}
