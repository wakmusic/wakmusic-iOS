import NeedleFoundation
import UIKit
import PlaylistFeatureInterface

public protocol PlaylistDetailFactoryDependency: Dependency {
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
}

public final class PlaylistDetailComponent: Component<PlaylistDetailFactoryDependency>, PlaylistDetailFactory {
    
    public func makeView(key: String, isMine: Bool) -> UIViewController {
        return isMine ? 
        dependency.myPlaylistDetailFactory.makeView(key: key) :
        dependency.unknownPlaylistDetailFactory.makeView(key: key)
    }


}
