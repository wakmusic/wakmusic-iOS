import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol WakmusicRecommendDependency: Dependency {
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
}

public final class WakmusicRecommendComponent: Component<WakmusicRecommendDependency> {
    public func makeView() -> UIViewController {
        let reactor = WakmusicRecommendReactor(
            fetchRecommendPlaylistUseCase: dependency.fetchRecommendPlaylistUseCase
        )

        return WakmusicRecommendViewController(
            playlistDetailFactory: dependency.playlistDetailFactory,
            reactor: reactor
        )
    }
}
