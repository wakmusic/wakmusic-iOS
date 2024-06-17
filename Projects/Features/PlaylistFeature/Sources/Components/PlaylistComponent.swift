import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol PlaylistDependency: Dependency {
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class PlaylistComponent: Component<PlaylistDependency>, PlaylistFactory {
    public func makeViewController() -> UIViewController {
        let viewModel = PlaylistViewModel()
        let viewController = PlaylistViewController(
            viewModel: viewModel,
            containSongsFactory: dependency.containSongsFactory
        )
        return viewController
    }
}