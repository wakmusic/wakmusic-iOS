import AuthDomainInterface
import AuthDomainTesting
import BaseFeatureInterface

// import BaseFeature
import BaseFeatureTesting
import MyInfoFeature
import MyInfoFeatureInterface
import SignInFeatureInterface
import SignInFeatureTesting
import UIKit
import UserDomainInterface
import UserDomainTesting

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
            serviceTermsFactory: ServiceTermsComponentStub(),
            privacyFactory: PrivacyComponentStub(),
            ppenSourceLicenseFactory: OpenSourceLicenseComponentStub()
        )
    }
}
