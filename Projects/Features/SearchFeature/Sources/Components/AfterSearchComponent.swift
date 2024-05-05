import BaseFeature
import Foundation
import NeedleFoundation
import SongsDomainInterface
import BaseFeatureInterface

public protocol AfterSearchDependency: Dependency {
    var afterSearchContentComponent: AfterSearchContentComponent { get }
    var fetchSearchSongUseCase: any FetchSearchSongUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(
            afterSearchContentComponent: dependency.afterSearchContentComponent,
            containSongsFactory: dependency.containSongsFactory,
            viewModel: .init(fetchSearchSongUseCase: dependency.fetchSearchSongUseCase)
        )
    }
}
