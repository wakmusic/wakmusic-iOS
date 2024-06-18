import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public protocol ServiceInfoDependency: Dependency {
    var openSourceLicenseFactory: any OpenSourceLicenseFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class ServiceInfoComponent: Component<ServiceInfoDependency>, ServiceInfoFactory {
    public func makeView() -> UIViewController {
        return ServiceInfoViewController.viewController(
            viewModel: ServiceInfoViewModel(),
            openSourceLicenseFactory: dependency.openSourceLicenseFactory,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
