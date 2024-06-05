import Foundation
import NeedleFoundation
import PlayListDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol WakmusicRecommendDependency: Dependency {
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase { get }
    var playlistDetailFacotry: any PlaylistDetailFactory { get }
}

public final class WakmusicRecommendComponent: Component<WakmusicRecommendDependency> {
    public func makeView() -> UIViewController {
        return WakmusicRecommendViewController(
            playlistDetailFactory: dependency.playlistDetailFacotry, reactor: WakmusicRecommendReactor(
                fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase
            )
        )
    }
}
