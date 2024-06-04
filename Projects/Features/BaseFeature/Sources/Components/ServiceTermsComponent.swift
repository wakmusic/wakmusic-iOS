import BaseFeatureInterface
import NeedleFoundation
import UIKit

public protocol ServiceTermsDependency: Dependency {}

public final class ServiceTermsComponent: Component<ServiceTermsDependency>, ServiceTermFactory {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .service)
    }
}
