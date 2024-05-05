import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import Foundation
import NeedleFoundation

public protocol ChartContentDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var fetchChartUpdateTimeUseCase: any FetchChartUpdateTimeUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class ChartContentComponent: Component<ChartContentDependency> {
    public func makeView(type: ChartDateType) -> ChartContentViewController {
        return ChartContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchChartRankingUseCase: dependency.fetchChartRankingUseCase,
                fetchChartUpdateTimeUseCase: dependency.fetchChartUpdateTimeUseCase
            ),
            containSongsFactory: dependency.containSongsFactory
        )
    }
}
