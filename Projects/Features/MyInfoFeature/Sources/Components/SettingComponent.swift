import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import NotificationDomainInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol SettingDependency: Dependency {
    var withdrawUserInfoUseCase: any WithdrawUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var updateNotificationTokenUseCase: any UpdateNotificationTokenUseCase { get }
    var textPopupFactory: any TextPopupFactory { get }
    var signInFactory: any SignInFactory { get }
    var serviceTermsFactory: any ServiceTermFactory { get }
    var privacyFactory: any PrivacyFactory { get }
    var openSourceLicenseFactory: any OpenSourceLicenseFactory { get }
    var playTypeTogglePopupFactory: any PlayTypeTogglePopupFactory { get }
}

public final class SettingComponent: Component<SettingDependency>, SettingFactory {
    public func makeView() -> UIViewController {
        return SettingViewController.viewController(
            reactor: SettingReactor(
                withDrawUserInfoUseCase: dependency.withdrawUserInfoUseCase,
                logoutUseCase: dependency.logoutUseCase,
                updateNotificationTokenUseCase: dependency.updateNotificationTokenUseCase
            ),
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory,
            serviceTermsFactory: dependency.serviceTermsFactory,
            privacyFactory: dependency.privacyFactory,
            openSourceLicenseFactory: dependency.openSourceLicenseFactory,
            playTypeTogglePopupFactory: dependency.playTypeTogglePopupFactory
        )
    }
}
