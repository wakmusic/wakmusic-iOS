import AuthDomainInterface
@testable import AuthDomainTesting
import Foundation
@testable import SignInFeature
import SignInFeatureInterface
import UIKit
import UserDomainInterface
@testable import UserDomainTesting

public final class SignInComponentStub: SignInFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return LoginViewController.viewController(
            viewModel: .init(
                fetchTokenUseCase: FetchTokenUseCaseSpy(),
                fetchUserInfoUseCase: FetchUserInfoUseCaseSpy()
            )
        )
    }
}
