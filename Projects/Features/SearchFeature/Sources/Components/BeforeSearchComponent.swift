import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import PlaylistFeatureInterface
import ChartDomainInterface

public protocol BeforeSearchDependency: Dependency {
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var fetchRecommendPlayListUseCase: any FetchRecommendPlayListUseCase { get }
    var fetchCurrentVideoUseCase: any FetchCurrentVideoUseCase { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var wakmusicRecommendComponent: WakmusicRecommendComponent { get }
}

public final class BeforeSearchComponent: Component<BeforeSearchDependency> {
    public func makeView() -> BeforeSearchContentViewController {
        return BeforeSearchContentViewController(
            wakmusicRecommendComponent: dependency.wakmusicRecommendComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            playlistDetailFactory: dependency.playlistDetailFactory,
            reactor: BeforeSearchReactor(
                fetchCurrentVideoUseCase: dependency.fetchCurrentVideoUseCase,
                fetchRecommendPlayListUseCase: dependency.fetchRecommendPlayListUseCase)
        )
    }
}
