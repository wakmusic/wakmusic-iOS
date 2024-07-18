import ArtistDomainInterface
import Foundation
import NeedleFoundation

public protocol ArtistDependency: Dependency {
    var fetchArtistListUseCase: any FetchArtistListUseCase { get }
    var artistDetailComponent: ArtistDetailComponent { get }
}

public final class ArtistComponent: Component<ArtistDependency> {
    public func makeView() -> ArtistViewController {
        let reactor = ArtistReactor(fetchArtistListUseCase: dependency.fetchArtistListUseCase)
        return ArtistViewController.viewController(
            reactor: reactor,
            artistDetailComponent: dependency.artistDetailComponent
        )
    }
}
