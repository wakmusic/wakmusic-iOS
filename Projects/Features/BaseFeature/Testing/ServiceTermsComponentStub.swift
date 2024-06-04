import BaseFeature
import BaseFeatureInterface
import UIKit

public final class ServiceTermComponentStub: ServiceTermFactoryStub {
    public func makeView() -> UIViewController {
        return ContractViewController.viewController(type: .service)
    }
}
