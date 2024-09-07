import BaseFeature
import ChartDomainInterface
import ChartFeatureInterface
import Foundation
import HomeFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import SongsDomainInterface
import UIKit

public protocol HomeDependency: Dependency {
    var fetchChartRankingUseCase: any FetchChartRankingUseCase { get }
    var fetchNewSongsUseCase: any FetchNewSongsUseCase { get }
    var fetchRecommendPlaylistUseCase: any FetchRecommendPlaylistUseCase { get }
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var chartFactory: any ChartFactory { get }
    var newSongsComponent: NewSongsComponent { get }
    var songDetailPresenter: any SongDetailPresentable { get }
}

public final class HomeComponent: Component<HomeDependency>, HomeFactory {
    public func makeView() -> UIViewController {
        return HomeViewController.viewController(
            viewModel: .init(
                fetchChartRankingUseCase: dependency.fetchChartRankingUseCase,
                fetchNewSongsUseCase: dependency.fetchNewSongsUseCase,
                fetchRecommendPlaylistUseCase: dependency.fetchRecommendPlaylistUseCase
            ),
            playlistDetailFactory: dependency.playlistDetailFactory,
            newSongsComponent: dependency.newSongsComponent,
            chartFactory: dependency.chartFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
