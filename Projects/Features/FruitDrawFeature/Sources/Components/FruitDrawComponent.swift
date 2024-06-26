import Foundation
import FruitDrawFeatureInterface
import NeedleFoundation
import UIKit

public protocol FruitDrawDependency: Dependency {}

public final class FruitDrawComponent: Component<FruitDrawDependency>, FruitDrawFactory {
    public func makeView() -> UIViewController {
        return FruitDrawViewController(viewModel: .init())
    }
}
