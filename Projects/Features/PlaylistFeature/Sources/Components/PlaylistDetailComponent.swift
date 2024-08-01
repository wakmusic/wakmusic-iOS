import NeedleFoundation
import PlaylistFeatureInterface
import PlaylistDomainInterface
import UIKit

public protocol PlaylistDetailFactoryDependency: Dependency {
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory { get }
    var requestPlaylistOwnerIdUsecase: any RequestPlaylistOwnerIdUsecase { get }
}

public final class PlaylistDetailComponent: Component<PlaylistDetailFactoryDependency>, PlaylistDetailFactory {
    
    public func makeView(key: String) -> UIViewController {
        
        let reactor = PlaylistDetailContainerReactor(key: key, requestPlaylistOwnerIdUsecase: dependency.requestPlaylistOwnerIdUsecase)
        
        return PlaylistDetailContainerViewController(reactor: reactor,
                                                     key: key,
                                                     unknownPlaylistDetailFactory: dependency.unknownPlaylistDetailFactory, myPlaylistDetailFactory: dependency.myPlaylistDetailFactory)
    }
    
    
    public func makeWmView(key: String) -> UIViewController {
        return dependency.wakmusicPlaylistDetailFactory.makeView(key: key)
    }
    

}
