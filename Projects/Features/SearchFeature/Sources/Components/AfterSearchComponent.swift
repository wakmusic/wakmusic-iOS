import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SongsDomainInterface

public protocol AfterSearchDependency: Dependency {
    var afterSearchContentComponent: AfterSearchContentComponent { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class AfterSearchComponent: Component<AfterSearchDependency> {
    public func makeView() -> AfterSearchViewController {
        return AfterSearchViewController.viewController(
            afterSearchContentComponent: dependency.afterSearchContentComponent,
            containSongsFactory: dependency.containSongsFactory,
            reactor: .init()
        )
    }
}
