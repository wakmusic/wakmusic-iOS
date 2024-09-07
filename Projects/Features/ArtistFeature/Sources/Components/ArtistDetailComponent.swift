import ArtistDomainInterface
import ArtistFeatureInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol ArtistDetailDependency: Dependency {
    var artistMusicComponent: ArtistMusicComponent { get }
    var fetchArtistDetailUseCase: any FetchArtistDetailUseCase { get }
    var fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase { get }
    var subscriptionArtistUseCase: any SubscriptionArtistUseCase { get }
    var textPopupFactory: any TextPopupFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class ArtistDetailComponent: Component<ArtistDetailDependency>, ArtistDetailFactory {
    public func makeView(artistID: String) -> UIViewController {
        return ArtistDetailViewController.viewController(
            viewModel: .init(
                artistID: artistID,
                fetchArtistDetailUseCase: dependency.fetchArtistDetailUseCase,
                fetchArtistSubscriptionStatusUseCase: dependency.fetchArtistSubscriptionStatusUseCase,
                subscriptionArtistUseCase: dependency.subscriptionArtistUseCase
            ),
            artistMusicComponent: dependency.artistMusicComponent,
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory
        )
    }
}
