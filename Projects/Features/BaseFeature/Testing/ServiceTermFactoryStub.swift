import BaseFeatureInterface
import UIKit

public protocol ServiceTermFactoryStub: ServiceTermFactory {
    func makeView() -> UIViewController
}
