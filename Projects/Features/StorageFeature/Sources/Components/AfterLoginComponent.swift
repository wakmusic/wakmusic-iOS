import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import UserDomainInterface

public protocol AfterLoginDependency: Dependency {
    var fetchUserInfoUseCase: any FetchUserInfoUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var requestComponent: RequestComponent { get }
    var profilePopComponent: ProfilePopComponent { get }
    var myPlayListComponent: MyPlayListComponent { get }
    var multiPurposePopUpFactory: any MultiPurposePopUpFactory { get }
    var favoriteComponent: FavoriteComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class AfterLoginComponent: Component<AfterLoginDependency> {
    public func makeView() -> AfterLoginViewController {
        return AfterLoginViewController.viewController(
            viewModel: .init(
                fetchUserInfoUseCase: dependency.fetchUserInfoUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            requestComponent: dependency.requestComponent,
            profilePopComponent: dependency.profilePopComponent,
            myPlayListComponent: dependency.myPlayListComponent,
            multiPurposePopUpFactory: dependency.multiPurposePopUpFactory,
            favoriteComponent: dependency.favoriteComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
