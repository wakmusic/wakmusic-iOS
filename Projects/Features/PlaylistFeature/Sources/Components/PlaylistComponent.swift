import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit

public protocol PlaylistDependency: Dependency {
    var containSongsFactory: any ContainSongsFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
    var textPopupFactory: any TextPopupFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class PlaylistComponent: Component<PlaylistDependency>, PlaylistFactory {
    public func makeViewController() -> UIViewController {
        let viewModel = PlaylistViewModel()
        let viewController = PlaylistViewController(
            currentSongID: nil,
            viewModel: viewModel,
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter,
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory
        )
        return viewController
    }

    public func makeViewController(currentSongID: String) -> UIViewController {
        let viewModel = PlaylistViewModel()
        let viewController = PlaylistViewController(
            currentSongID: currentSongID,
            viewModel: viewModel,
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter,
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory
        )
        return viewController
    }
}
