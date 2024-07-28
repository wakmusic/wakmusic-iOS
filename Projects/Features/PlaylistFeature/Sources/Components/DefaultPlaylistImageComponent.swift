import BaseFeature
import BaseFeatureInterface
import ImageDomainInterface
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol DefaultPlaylistCoverDependency: Dependency {
    var fetchDefaultPlaylistImageUseCase: any FetchDefaultPlaylistImageUseCase { get }
}

public final class DefaultPlaylistCoverComponent: Component<DefaultPlaylistCoverDependency>,
    DefaultPlaylistCoverFactory {
    public func makeView(_ delegate: any DefaultPlaylistCoverDelegate) -> UIViewController {
        DefaultPlaylistCoverViewController(delegate: delegate, reactor: DefaultPlaylistCoverReactor(
            fetchDefaultPlaylistImageUseCase: dependency.fetchDefaultPlaylistImageUseCase

        ))
    }
}
