@testable import BaseFeature
import BaseFeatureInterface
import UIKit

public final class ServiceTermComponentStub: ServiceTermFactory {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .service)
    }
}
