import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import PlaylistFeatureInterface

public protocol BeforeSearchDependency: Dependency {
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var wakmusicRecommendComponent: WakmusicRecommendComponent { get }
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController(
            wakmusicRecommendComponent: dependency.wakmusicRecommendComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            reactor: BeforeSearchReactor(fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase)
        )
    }
}
