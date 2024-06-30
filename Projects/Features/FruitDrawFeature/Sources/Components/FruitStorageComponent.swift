import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import FruitDrawFeatureInterface
import NeedleFoundation
import UIKit
import UserDomainInterface

public protocol FruitStorageDependency: Dependency {
    var fetchFruitListUseCase: any FetchFruitListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class FruitStorageComponent: Component<FruitStorageDependency>, FruitStorageFactory {
    public func makeView() -> UIViewController {
        return FruitStorageViewController(
            viewModel: .init(
                fetchFruitListUseCase: dependency.fetchFruitListUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
