import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeature
import UserDomainInterface

public protocol FavoriteDependency: Dependency {
    var containSongsComponent: ContainSongsComponent { get }
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase { get }
    var editFavoriteSongsOrderUseCase: any EditFavoriteSongsOrderUseCase { get }
    var deleteFavoriteListUseCase: any DeleteFavoriteListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class FavoriteComponent: Component<FavoriteDependency> {
    public func makeView() -> FavoriteViewController {
        return FavoriteViewController.viewController(
            viewModel: .init(
                fetchFavoriteSongsUseCase: dependency.fetchFavoriteSongsUseCase,
                editFavoriteSongsOrderUseCase: dependency.editFavoriteSongsOrderUseCase,
                deleteFavoriteListUseCase: dependency.deleteFavoriteListUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            containSongsComponent: dependency.containSongsComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
