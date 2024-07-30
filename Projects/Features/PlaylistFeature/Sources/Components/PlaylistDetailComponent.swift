import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol PlaylistDetailFactoryDependency: Dependency {
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory { get }
}

public final class PlaylistDetailComponent: Component<PlaylistDetailFactoryDependency>, PlaylistDetailFactory {
    
    public func makeView(key: String) -> UIViewController {
        return dependency.wakmusicPlaylistDetailFactory.makeView(key: key)
    }
    
    public func makeView(key: String, ownerId: String) -> UIViewController {
        return PlaylistDetailContainerViewController(key: key, ownerId: ownerId,
                                                     unknownPlaylistDetailFactory: dependency.unknownPlaylistDetailFactory,
                                                     myPlaylistDetailFactory: dependency.myPlaylistDetailFactory)
    }
    

}
