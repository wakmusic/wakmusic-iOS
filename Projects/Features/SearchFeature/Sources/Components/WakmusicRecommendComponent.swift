import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol WakmusicRecommendDependency: Dependency {
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase { get }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory { get }
}

public final class WakmusicRecommendComponent: Component<WakmusicRecommendDependency> {
    public func makeView() -> UIViewController {
        let reactor = WakmusicRecommendReactor(
            fetchRecommendPlaylistUseCase: dependency.fetchRecommendPlaylistUseCase
        )

        return WakmusicRecommendViewController(
            wakmusicPlaylistDetailFactory: dependency.wakmusicPlaylistDetailFactory,
            reactor: reactor
        )
    }
}
