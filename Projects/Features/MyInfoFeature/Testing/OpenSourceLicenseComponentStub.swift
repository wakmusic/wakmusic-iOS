import Foundation
@testable import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class OpenSourceLicenseComponentStub: OpenSourceLicenseFactory {
    public func makeView() -> UIViewController {
        return OpenSourceLicenseViewController.viewController(
            viewModel: OpenSourceLicenseViewModel()
        )
    }
}
