import ArtistDomainInterface
import ArtistFeatureInterface
import Foundation
import NeedleFoundation
import UIKit

public protocol ArtistDependency: Dependency {
    var fetchArtistListUseCase: any FetchArtistListUseCase { get }
    var artistDetailFactory: any ArtistDetailFactory { get }
}

public final class ArtistComponent: Component<ArtistDependency>, ArtistFactory {
    public func makeView() -> UIViewController {
        let reactor = ArtistReactor(fetchArtistListUseCase: dependency.fetchArtistListUseCase)
        return ArtistViewController.viewController(
            reactor: reactor,
            artistDetailFactory: dependency.artistDetailFactory
        )
    }
}
