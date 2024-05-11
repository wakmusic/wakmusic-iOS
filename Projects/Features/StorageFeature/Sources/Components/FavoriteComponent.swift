import AuthDomainInterface
import BaseDomainInterface
import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import UserDomainInterface
import UIKit

public protocol FavoriteDependency: Dependency {
    var containSongsFactory: any ContainSongsFactory { get }
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase { get }
    var editFavoriteSongsOrderUseCase: any EditFavoriteSongsOrderUseCase { get }
    var deleteFavoriteListUseCase: any DeleteFavoriteListUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class FavoriteComponent: Component<FavoriteDependency> {
    public func makeView() -> UIViewController {
        return FavoriteViewController.viewController(
            reactor: FavoriteReactoer() ,
            containSongsFactory: dependency.containSongsFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
