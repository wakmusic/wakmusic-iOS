import AuthDomainInterface
import Foundation
import NeedleFoundation
import UserDomainInterface
import ImageDomainInterface

public protocol ProfilePopDependency: Dependency {
    var fetchProfileListUseCase: any FetchProfileListUseCase { get }
    var setProfileUseCase: any SetProfileUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class ProfilePopComponent: Component<ProfilePopDependency> {
    public func makeView() -> ProfilePopViewController {
        return ProfilePopViewController.viewController(
            viewModel: .init(
                fetchProfileListUseCase: dependency.fetchProfileListUseCase,
                setProfileUseCase: dependency.setProfileUseCase,
                logoutUseCas: dependency.logoutUseCase
            )
        )
    }
}
