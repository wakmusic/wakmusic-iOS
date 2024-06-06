import AuthDomainInterface
import AuthDomainTesting
import Foundation
@testable import SignInFeature
import SignInFeatureInterface
import UIKit
import UserDomainInterface
import UserDomainTesting

public final class SignInComponentStub: SignInFactory {
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
