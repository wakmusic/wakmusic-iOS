import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface

public protocol BeforeSearchDependency: Dependency {
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase { get }
    var fetchCurrentVideoUseCase: any FetchCurrentVideoUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var wakmusicRecommendComponent: WakmusicRecommendComponent { get }
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory { get }
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController(
            wakmusicRecommendComponent: dependency.wakmusicRecommendComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            myPlaylistDetailFactory: dependency.myPlaylistDetailFactory,
            unknownPlaylistDetailFactory: dependency.unknownPlaylistDetailFactory, 
            wakmusicPlaylistDetailFactory: dependency.wakmusicPlaylistDetailFactory,
            reactor: BeforeSearchReactor(
                fetchCurrentVideoUseCase: dependency.fetchCurrentVideoUseCase,
                fetchRecommendPlaylistUseCase: dependency.fetchRecommendPlaylistUseCase
            )
        )
    }
}
