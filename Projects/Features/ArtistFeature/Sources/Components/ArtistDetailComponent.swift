import BaseFeatureInterface
import ArtistDomainInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface

public protocol ArtistDetailDependency: Dependency {
    var artistMusicComponent: ArtistMusicComponent { get }
    var fetchArtistSubscriptionStatusUseCase: any FetchArtistSubscriptionStatusUseCase { get }
    var subscriptionArtistUseCase: any SubscriptionArtistUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class ArtistDetailComponent: Component<ArtistDetailDependency> {
    public func makeView(model: ArtistListEntity) -> ArtistDetailViewController {
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
