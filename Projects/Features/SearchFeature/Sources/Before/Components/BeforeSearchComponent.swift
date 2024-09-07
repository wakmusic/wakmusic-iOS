import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol BeforeSearchDependency: Dependency {
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase { get }
    var fetchCurrentVideoUseCase: any FetchCurrentVideoUseCase { get }
    var wakmusicRecommendComponent: WakmusicRecommendComponent { get }
    var textPopupFactory: any TextPopupFactory { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> UIViewController {
        return BeforeSearchContentViewController(
            wakmusicRecommendComponent: dependency.wakmusicRecommendComponent,
            textPopupFactory: dependency.textPopupFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            reactor: BeforeSearchReactor(
                fetchCurrentVideoUseCase: dependency.fetchCurrentVideoUseCase,
                fetchRecommendPlaylistUseCase: dependency.fetchRecommendPlaylistUseCase
            )
        )
    }
}
