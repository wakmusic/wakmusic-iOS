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
            textPopupFactory: TextPopupComponentStub(),
            signInFactory: SignInComponentStub(),
            serviceTermsFactory: ServiceTermComponentStub(),
            privacyFactory: PrivacyComponentStub(),
            openSourceLicenseFactory: OpenSourceLicenseComponentStub(),
            playTypeTogglePopupFactory: PlayTypeTogglePopupComponentStub()
        )
    }
}

final class PlayTypeTogglePopupComponentStub: PlayTypeTogglePopupFactory {
    public func makeView(
        completion: ((_ selectedItemString: String) -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        return PlayTypeTogglePopupViewController(
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
