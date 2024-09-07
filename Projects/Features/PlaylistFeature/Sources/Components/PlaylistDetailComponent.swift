import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol PlaylistDetailFactoryDependency: Dependency {
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var wakmusicPlaylistDetailFactory: any WakmusicPlaylistDetailFactory { get }
    var requestPlaylistOwnerIDUsecase: any RequestPlaylistOwnerIDUsecase { get }
    var textPopupFactory: any TextPopupFactory { get }
}

public final class PlaylistDetailComponent: Component<PlaylistDetailFactoryDependency>, PlaylistDetailFactory {
    public func makeView(key: String) -> UIViewController {
        let reactor = PlaylistDetailContainerReactor(
            key: key,
            requestPlaylistOwnerIDUsecase: dependency.requestPlaylistOwnerIDUsecase
        )
        return PlaylistDetailContainerViewController(
            reactor: reactor,
            key: key,
            unknownPlaylistDetailFactory: dependency
                .unknownPlaylistDetailFactory,
            myPlaylistDetailFactory: dependency.myPlaylistDetailFactory,
            textPopupFactory: dependency.textPopupFactory
        )
    }

    public func makeWmView(key: String) -> UIViewController {
        return dependency.wakmusicPlaylistDetailFactory.makeView(key: key)
    }
}
