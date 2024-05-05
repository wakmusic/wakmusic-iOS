import Foundation
import NeedleFoundation
import SignInFeatureInterface

public protocol StorageDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var afterLoginComponent: AfterLoginComponent { get }
}

public final class StorageComponent: Component<StorageDependency> {
    public func makeView() -> StorageViewController {
        return StorageViewController.viewController(
            signInFactory: dependency.signInFactory,
            afterLoginComponent: dependency.afterLoginComponent
        )
    }
}
