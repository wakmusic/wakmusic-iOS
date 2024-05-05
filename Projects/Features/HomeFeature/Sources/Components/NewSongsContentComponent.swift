
import BaseFeature
import ChartDomainInterface
import Foundation
import NeedleFoundation
import SongsDomainInterface
import BaseFeatureInterface

public protocol NewSongsContentDependency: Dependency {
    var fetchNewSongsUseCase: any FetchNewSongsUseCase { get }
    var fetchChartUpdateTimeUseCase: any FetchChartUpdateTimeUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class NewSongsContentComponent: Component<NewSongsContentDependency> {
    public func makeView(type: NewSongGroupType) -> NewSongsContentViewController {
        return NewSongsContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchNewSongsUseCase: dependency.fetchNewSongsUseCase,
                fetchChartUpdateTimeUseCase: dependency.fetchChartUpdateTimeUseCase
            ),
            containSongsFactory: dependency.containSongsFactory
        )
    }
}
