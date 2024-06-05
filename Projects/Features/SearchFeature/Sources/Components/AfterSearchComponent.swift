import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SongsDomainInterface
import SearchFeatureInterface

public protocol AfterSearchDependency: Dependency {
    var searchResultFactory: any SearchResultFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(
            searchResultFactory: dependency.searchResultFactory,
            containSongsFactory: dependency.containSongsFactory,
            reactor: .init()
        )
    }
}
