import AuthDomainInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import UIKit
import UserDomainInterface

public protocol SignInDependency: Dependency {
    var fetchTokenUseCase: any FetchTokenUseCase { get }
    var fetchNaverUserInfoUseCase: any FetchNaverUserInfoUseCase { get }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase { get }
}

public final class SignInComponent: Component<SignInDependency>, SignInFactory {
    public func makeWarnigView(_ frame: CGRect?, text: String?, _ completion: @escaping () -> Void) -> UIView {
        return LoginWarningView(
            frame: frame ?? CGRect(x: .zero, y: .zero, width: 164, height: 176),
            text: text,
            completion
        )
    }

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
