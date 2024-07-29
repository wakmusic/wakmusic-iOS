import BaseFeature
import BaseFeatureInterface
import ChartDomainInterface
import Foundation
import NeedleFoundation
import SongsDomainInterface

public protocol NewSongsContentDependency: Dependency {
    var fetchNewSongsUseCase: any FetchNewSongsUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
}

public final class NewSongsContentComponent: Component<NewSongsContentDependency> {
    public func makeView(type: NewSongGroupType) -> NewSongsContentViewController {
        return NewSongsContentViewController.viewController(
            viewModel: .init(
                type: type,
                fetchNewSongsUseCase: dependency.fetchNewSongsUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter
        )
    }
}
