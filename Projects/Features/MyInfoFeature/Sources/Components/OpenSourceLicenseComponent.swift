import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public protocol OpenSourceLicenseDependency: Dependency {}

public final class OpenSourceLicenseComponent: Component<OpenSourceLicenseDependency>, OpenSourceLicenseFactory {
    public func makeView() -> UIViewController {
        return OpenSourceLicenseViewController.viewController(
            viewModel: OpenSourceLicenseViewModel()
        )
    }
}
