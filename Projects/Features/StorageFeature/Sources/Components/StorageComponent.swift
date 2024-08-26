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
    var textPopupFactory: any TextPopupFactory { get }
    var multiPurposePopupFactory: any MultiPurposePopupFactory { get }
    var listStorageComponent: ListStorageComponent { get }
    var likeStorageComponent: LikeStorageComponent { get }
}

public final class StorageComponent: Component<StorageDependency>, StorageFactory {
    public func makeView() -> UIViewController {
        return StorageViewController.viewController(
            reactor: StorageReactor(
                storageCommonService: DefaultStorageCommonService.shared
            ),
            listStorageComponent: dependency.listStorageComponent,
            multiPurposePopupFactory: dependency.multiPurposePopupFactory,
            likeStorageComponent: dependency.likeStorageComponent,
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
