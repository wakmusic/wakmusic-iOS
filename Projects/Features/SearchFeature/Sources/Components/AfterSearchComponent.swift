import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import SongsDomainInterface

public protocol AfterSearchDependency: Dependency {
    var songSearchResultFactory: any SongSearchResultFactory { get }
    var listSearchResultFactory: any ListSearchResultFactory { get }
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(
            songSearchResultFactory: dependency.songSearchResultFactory,
            listSearchResultFactory: dependency.listSearchResultFactory,
            reactor: .init()
        )
    }
}
