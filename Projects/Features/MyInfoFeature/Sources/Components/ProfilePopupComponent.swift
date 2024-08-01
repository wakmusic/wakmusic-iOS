import AuthDomainInterface
import Foundation
import ImageDomainInterface
import NeedleFoundation
import UserDomainInterface
import MyInfoFeatureInterface
import UIKit

public protocol ProfilePopupDependency: Dependency {
    var fetchProfileListUseCase: any FetchProfileListUseCase { get }
    var setProfileUseCase: any SetProfileUseCase { get }
}

public final class ProfilePopupComponent: Component<ProfilePopupDependency>, ProfilePopupFactory {
    public func makeView(completion: (() -> Void)?) -> UIViewController {
        return ProfilePopupViewController.viewController(
            viewModel: .init(
                fetchProfileListUseCase: dependency.fetchProfileListUseCase,
                setProfileUseCase: dependency.setProfileUseCase
            ),
            completion: completion
        )
    }
}
