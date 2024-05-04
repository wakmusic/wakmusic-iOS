import Foundation
import NeedleFoundation
import BaseFeatureInterface

public protocol ServiceInfoDependency: Dependency {
    var openSourceLicenseComponent: OpenSourceLicenseComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class ServiceInfoComponent: Component<ServiceInfoDependency> {
    public func makeView() -> ServiceInfoViewController {
        return ServiceInfoViewController.viewController(
            viewModel: ServiceInfoViewModel(),
            openSourceLicenseComponent: dependency.openSourceLicenseComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
