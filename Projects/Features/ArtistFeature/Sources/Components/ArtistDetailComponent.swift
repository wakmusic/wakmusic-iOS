import ArtistDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import ArtistFeatureInterface
import UIKit

public protocol ArtistDetailDependency: Dependency {
    var artistMusicComponent: ArtistMusicComponent { get }
    var fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase { get }
    var subscriptionArtistUseCase: any SubscriptionArtistUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class ArtistDetailComponent: Component<ArtistDetailDependency>, ArtistDetailFactory {
    public func makeView(model: ArtistListEntity) -> UIViewController {
        return ArtistDetailViewController.viewController(
            viewModel: .init(
                model: model,
                fetchArtistSubscriptionStatusUseCase: dependency.fetchArtistSubscriptionStatusUseCase,
                subscriptionArtistUseCase: dependency.subscriptionArtistUseCase
            ),
            artistMusicComponent: dependency.artistMusicComponent,
            textPopupFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
