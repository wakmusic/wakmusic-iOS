import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import StorageFeatureInterface
import UIKit

public protocol StorageDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var myPlayListComponent: MyPlayListComponent { get }
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var favoriteComponent: FavoriteComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class StorageComponent: Component<StorageDependency>, StorageFactory {
    public func makeView() -> UIViewController {
        return StorageViewController.viewController(
            reactor: StorageReactor(),
            myPlayListComponent: dependency.myPlayListComponent,
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            favoriteComponent: dependency.favoriteComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
