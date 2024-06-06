import Foundation
import UIKit
import MyInfoFeature
import MyInfoFeatureInterface

public final class OpenSourceLicenseComponentStub: OpenSourceLicenseFactory {
    public func makeView() -> UIViewController {
        return OpenSourceLicenseViewController.viewController(
            viewModel: OpenSourceLicenseViewModel()
        )
    }
}
