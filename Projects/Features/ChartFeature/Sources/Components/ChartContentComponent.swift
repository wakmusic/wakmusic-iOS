import Foundation
import NeedleFoundation
import DomainModule
import DataMappingModule

public protocol ChartContentDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var fetchChartUpdateTimeUseCase: any FetchChartUpdateTimeUseCase { get }
}

public final class ChartContentComponent: Component<ChartContentDependency> {
    public func makeView(type: ChartDateType) -> ChartContentViewController {
        return ChartContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchChartRankingUseCase: dependency.fetchChartRankingUseCase,
                fetchChartUpdateTimeUseCase: dependency.fetchChartUpdateTimeUseCase
            )
        )
    }
}
