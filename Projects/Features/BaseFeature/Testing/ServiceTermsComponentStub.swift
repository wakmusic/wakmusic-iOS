@testable import BaseFeature
import BaseFeatureInterface
import UIKit

public final class ServiceTermComponentStub: ServiceTermFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .service)
    }
}
