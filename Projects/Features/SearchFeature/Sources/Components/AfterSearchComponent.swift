import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import SongsDomainInterface

public protocol AfterSearchDependency: Dependency {
    var songSearchResultFactory: any SongSearchResultFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(
            songSearchResultFactory: dependency.songSearchResultFactory,
            containSongsFactory: dependency.containSongsFactory,
            reactor: .init()
        )
    }
}
