import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import Foundation
import NeedleFoundation

public protocol ChartContentDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
}

public final class ChartContentComponent: Component<ChartContentDependency> {
    public func makeView(type: ChartDateType) -> ChartContentViewController {
        return ChartContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchChartRankingUseCase: dependency.fetchChartRankingUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
