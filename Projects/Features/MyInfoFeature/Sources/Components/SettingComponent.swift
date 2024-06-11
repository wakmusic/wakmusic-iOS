import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol SettingDependency: Dependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
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
            reactor: SettingReactor(
                withDrawUserInfoUseCase: dependency.withdrawUserInfoUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory,
            appPushSettingFactory: dependency.appPushSettingComponent,
            serviceTermsFactory: dependency.serviceTermsComponent,
            privacyFactory: dependency.privacyComponent,
            openSourceLicenseFactory: dependency.openSourceLicenseComponent
        )
    }
}
