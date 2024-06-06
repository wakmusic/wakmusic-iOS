//import BaseFeatureInterface
import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class AppPushSettingComponentStub: AppPushSettingFactory {
    public func makeView() -> UIViewController {
        return AppPushSettingViewController.viewController(
            reactor: AppPushSettingReactor()
        )
    }
}
