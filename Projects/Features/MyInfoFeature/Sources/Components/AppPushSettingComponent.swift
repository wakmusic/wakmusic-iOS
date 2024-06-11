// import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public protocol AppPushSettingDependency: Dependency {}

public final class AppPushSettingComponent: Component<AppPushSettingDependency>, AppPushSettingFactory {
    public func makeView() -> UIViewController {
        return AppPushSettingViewController.viewController(
            reactor: AppPushSettingReactor()
        )
    }
}
