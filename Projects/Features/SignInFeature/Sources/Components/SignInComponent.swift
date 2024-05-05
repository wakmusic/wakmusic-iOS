import AuthDomainInterface
import Foundation
import NeedleFoundation
import UserDomainInterface
import SignInFeatureInterface
import UIKit

public protocol SignInDependency: Dependency {
    var fetchTokenUseCase: any FetchTokenUseCase { get }
    var fetchNaverUserInfoUseCase: any FetchNaverUserInfoUseCase { get }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase { get }
}

public final class SignInComponent: Component<SignInDependency>, SignInFactory {
    public func makeView() -> UIViewController {
        return LoginViewController.viewController(
            viewModel: .init(
                fetchTokenUseCase: dependency.fetchTokenUseCase,
                fetchNaverUserInfoUseCase: dependency.fetchNaverUserInfoUseCase,
                fetchUserInfoUseCase: dependency.fetchUserInfoUseCase
            )
        )
    }

}
