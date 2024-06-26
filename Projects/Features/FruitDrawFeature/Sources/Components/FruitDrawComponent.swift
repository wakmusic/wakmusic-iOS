import Foundation
import NeedleFoundation
import FruitDrawFeatureInterface
import UIKit

public protocol FruitDrawDependency: Dependency {}

public final class FruitDrawComponent: Component<FruitDrawDependency>, FruitDrawFactory {
    public func makeView() -> UIViewController {
        return FruitDrawViewController(viewModel: .init())
    }
}
