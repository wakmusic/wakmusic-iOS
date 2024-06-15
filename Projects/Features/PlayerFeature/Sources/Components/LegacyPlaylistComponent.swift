import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation

public protocol LegacyPlaylistDependency: Dependency {
    var containSongsFactory: any ContainSongsFactory { get }
}

public final class LegacyPlaylistComponent: Component<LegacyPlaylistDependency> {
    public func makeView() -> PlaylistViewController {
        return PlaylistViewController(
            viewModel: .init(),
            containSongsFactory: dependency.containSongsFactory
        )
    }
}
