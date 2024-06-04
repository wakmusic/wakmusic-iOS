import AuthDomainInterface
import AuthDomainTesting
import Foundation
import SignInFeature
import SignInFeatureInterface
import UIKit
import UserDomainInterface
import UserDomainTesting

public final class SignInComponentStub: SignInFactoryStub {
    public func makeView() -> UIViewController {
        return LoginViewController.viewController(
            viewModel: .init(
                fetchTokenUseCase: FetchTokenUseCaseSpy(),
                fetchNaverUserInfoUseCase: FetchNaverUserInfoUseCaseSpy(),
                fetchUserInfoUseCase: FetchUserInfoUseCaseSpy()
            )
        )
    }
}
