import AuthDomainInterface
@testable import AuthDomainTesting
import BaseFeatureInterface
@testable import BaseFeatureTesting
@testable import MyInfoFeature
import MyInfoFeatureInterface
import NotificationDomainInterface
import SignInFeatureInterface
@testable import SignInFeatureTesting
import UIKit
import UserDomainInterface
@testable import UserDomainTesting

public final class SettingComponentStub: SettingFactory {
    public func makeView() -> UIViewController {
        return SettingViewController.viewController(
            reactor: SettingReactor(
                withDrawUserInfoUseCase: WithdrawUserInfoUseCaseSpy(),
                logoutUseCase: LogoutUseCaseSpy(),
                updateNotificationTokenUseCase: UpdateNotificationTokenUseCaseSpy()
            ),
            textPopUpFactory: TextPopUpComponentStub(),
            signInFactory: SignInComponentStub(),
            serviceTermsFactory: ServiceTermComponentStub(),
            privacyFactory: PrivacyComponentStub(),
            openSourceLicenseFactory: OpenSourceLicenseComponentStub()
        )
    }
}
