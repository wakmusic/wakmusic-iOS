@testable import FruitDrawFeature
import FruitDrawFeatureInterface
import UIKit

public final class FruitDrawComponentStub: FruitDrawFactory {
    public func makeView() -> UIViewController {
        return FruitDrawViewController(viewModel: .init())
    }
}
