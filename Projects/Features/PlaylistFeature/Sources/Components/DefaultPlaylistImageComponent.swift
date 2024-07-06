import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol DefaultPlaylistImageDependency: Dependency {
    #warning("usecase 주입")
    //
}

public final class DefaultPlaylistImageComponent: Component<DefaultPlaylistImageDependency>,
    DefaultPlaylistImageFactory {
    public func makeView(_ delegate: any DefaultPlaylistImageDelegate) -> UIViewController {
        DefaultPlaylistImageViewController(delegate: delegate, reactor: DefaultPlaylistImageReactor())
    }
}
