import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit

public protocol PlaylistDependency: Dependency {
    var containSongsFactory: any ContainSongsFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class PlaylistComponent: Component<PlaylistDependency>, PlaylistFactory {
    public func makeViewController() -> UIViewController {
        let viewModel = PlaylistViewModel()
        let viewController = PlaylistViewController(
            viewModel: viewModel,
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter,
            textPopUpFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
        return viewController
    }
}
