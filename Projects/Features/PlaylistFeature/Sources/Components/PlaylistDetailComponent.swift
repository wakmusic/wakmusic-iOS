import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol PlaylistDetailFactoryDependency: Dependency {
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory { get }
}

public final class PlaylistDetailComponent: Component<PlaylistDetailFactoryDependency>, PlaylistDetailFactory {
    public func makeView(key: String, kind: PlaylistDetailKind) -> UIViewController {
        switch kind {
        case .my:
            return dependency.myPlaylistDetailFactory.makeView(key: key)
        case .unknown:
            return dependency.unknownPlaylistDetailFactory.makeView(key: key)
        case .wakmu:
            return dependency.wakmusicPlaylistDetailFactory.makeView(key: key)
        }
    }
}
