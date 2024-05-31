import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol SettingDependency: Dependency {
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class SettingComponent: Component<SettingDependency>, SettingFactory {
    public func makeView() -> UIViewController {
        return SettingViewController.viewController(
            reactor: SettingReactor(),
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
