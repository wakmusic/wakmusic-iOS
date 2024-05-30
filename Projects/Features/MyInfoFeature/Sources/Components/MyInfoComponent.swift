import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol MyInfoDependency: Dependency {
    var signInFactory: any SignInFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController.viewController(
            reactor: MyInfoReactor(),
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
