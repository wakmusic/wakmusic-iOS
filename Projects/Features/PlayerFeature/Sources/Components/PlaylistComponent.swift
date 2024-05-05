import BaseFeature
import Foundation
import NeedleFoundation
import BaseFeatureInterface

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
