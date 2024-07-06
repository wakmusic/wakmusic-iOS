import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import ImageDomainInterface
import UIKit

public protocol DefaultPlaylistImageDependency: Dependency {
    var fetchDefaultPlaylistImageUseCase: any FetchDefaultPlaylistImageUseCase { get }
}

public final class DefaultPlaylistImageComponent: Component<DefaultPlaylistImageDependency>,
    DefaultPlaylistImageFactory {
    public func makeView(_ delegate: any DefaultPlaylistImageDelegate) -> UIViewController {
        DefaultPlaylistImageViewController(delegate: delegate, reactor: DefaultPlaylistImageReactor(
            fetchDefaultPlaylistImageUseCase: dependency.fetchDefaultPlaylistImageUseCase

        ))
    }
}
