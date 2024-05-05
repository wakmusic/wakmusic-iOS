import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation

public protocol PlaylistDependency: Dependency {
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class PlaylistComponent: Component<PlaylistDependency> {
    public func makeView() -> PlaylistViewController {
        return PlaylistViewController(
            viewModel: .init(),
            containSongsFactory: dependency.containSongsFactory
        )
    }
}
