import ChartDomainInterface
import CommonFeature
import Foundation
import NeedleFoundation

public protocol ChartContentDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var fetchChartUpdateTimeUseCase: any FetchChartUpdateTimeUseCase { get }
    var containSongsComponent: ContainSongsComponent { get }
}

public final class ChartContentComponent: Component<ChartContentDependency> {
    public func makeView(type: ChartDateType) -> ChartContentViewController {
        return ChartContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchChartRankingUseCase: dependency.fetchChartRankingUseCase,
                fetchChartUpdateTimeUseCase: dependency.fetchChartUpdateTimeUseCase
            ),
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
