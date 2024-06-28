import Foundation
import FruitDrawFeatureInterface
import NeedleFoundation
import UIKit
import UserDomainInterface

public protocol FruitDrawDependency: Dependency {
    var fetchFruitDrawStatusUseCase: any FetchFruitDrawStatusUseCase { get }
    var drawFruitUseCase: any DrawFruitUseCase { get }
}

public final class FruitDrawComponent: Component<FruitDrawDependency>, FruitDrawFactory {
    public func makeView() -> UIViewController {
        return FruitDrawViewController(
            viewModel: .init(
                fetchFruitDrawStatusUseCase: dependency.fetchFruitDrawStatusUseCase,
                drawFruitUseCase: dependency.drawFruitUseCase
            )
        )
    }
}
