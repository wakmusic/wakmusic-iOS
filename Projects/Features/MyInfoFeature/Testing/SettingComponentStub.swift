import AuthDomainInterface
import AuthDomainTesting
import BaseFeatureInterface
import MyInfoFeatureInterface
import SignInFeatureInterface
import UIKit
import UserDomainInterface
import UserDomainTesting
@testable import MyInfoFeature
@testable import BaseFeatureTesting
@testable import SignInFeatureTesting

public final class SettingComponentStub: SettingFactory {
    public func makeView() -> UIViewController {
        return SettingViewController.viewController(
            reactor: SettingReactor(
                withDrawUserInfoUseCase: WithdrawUserInfoUseCaseSpy(),
                logoutUseCase: LogoutUseCaseSpy()
            ),
            textPopUpFactory: TextPopUpComponentStub(),
            signInFactory: SignInComponentStub(),
            appPushSettingFactory: AppPushSettingComponentStub(),
            serviceTermsFactory: ServiceTermComponentStub(),
            privacyFactory: PrivacyComponentStub(),
            openSourceLicenseFactory: OpenSourceLicenseComponentStub()
        )
    }
}
