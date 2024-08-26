import BaseFeatureInterface
import Foundation
import FruitDrawFeatureInterface
import NeedleFoundation
import UIKit
import UserDomainInterface

public protocol FruitStorageDependency: Dependency {
    var fetchFruitListUseCase: any FetchFruitListUseCase { get }
    var textPopupFactory: any TextPopupFactory { get }
}

public final class FruitStorageComponent: Component<FruitStorageDependency>, FruitStorageFactory {
    public func makeView() -> UIViewController {
        return FruitStorageViewController(
            viewModel: .init(
                fetchFruitListUseCase: dependency.fetchFruitListUseCase
            ),
            textPopupFactory: dependency.textPopupFactory
        )
    }
}
