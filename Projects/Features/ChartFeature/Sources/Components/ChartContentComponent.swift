import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import Foundation
import NeedleFoundation
import SignInFeatureInterface

public protocol ChartContentDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var textPopupFactory: any TextPopupFactory { get }
    var signInFactory: any SignInFactory { get }
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
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
