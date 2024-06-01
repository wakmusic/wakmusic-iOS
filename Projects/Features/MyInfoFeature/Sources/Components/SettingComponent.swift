import BaseFeature
import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol SettingDependency: Dependency {
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
    var appPushSettingComponent: AppPushSettingComponent { get }
    var serviceTermsComponent: ServiceTermsComponent { get }
    var privacyComponent: PrivacyComponent { get }
    var openSourceLicenseComponent: OpenSourceLicenseComponent { get }
}

public final class SettingComponent: Component<SettingDependency>, SettingFactory {
    public func makeView() -> UIViewController {
        return SettingViewController.viewController(
            reactor: SettingReactor(),
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory,
            appPushSettingComponent: dependency.appPushSettingComponent,
            serviceTermsComponent: dependency.serviceTermsComponent,
            privacyComponent: dependency.privacyComponent,
            openSourceLicenseComponent: dependency.openSourceLicenseComponent
        )
    }
}
