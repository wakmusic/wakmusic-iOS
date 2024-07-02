import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol ThumbnailPopupDependency: Dependency {

}

public final class ThumbnailPopupComponent: Component<ThumbnailPopupDependency>, ThumbnailPopupFactory {
    public func makeView(delegate: any ThumbnailPopupDelegate) -> UIViewController {
            ThumbnailPopupViewController(reactor: ThumbnailPopupReactor(), delegate: delegate)
    }
    
}
