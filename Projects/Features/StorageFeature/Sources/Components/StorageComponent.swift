import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import StorageFeatureInterface
import UIKit
import UserDomainInterface

public protocol StorageDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var multiPurposePopUpFactory: any MultiPurposePopupFactory { get }
    var listStorageComponent: ListStorageComponent { get }
    var likeStorageComponent: LikeStorageComponent { get }
}

public final class StorageComponent: Component<StorageDependency>, StorageFactory {
    public func makeView() -> UIViewController {
        return StorageViewController.viewController(
            reactor: StorageReactor(),
            listStorageComponent: dependency.listStorageComponent,
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            likeStorageComponent: dependency.likeStorageComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
