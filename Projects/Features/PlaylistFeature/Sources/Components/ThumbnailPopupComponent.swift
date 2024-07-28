import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import PriceDomainInterface
import UIKit

public protocol ThumbnailPopupDependency: Dependency {
    var fetchPlaylistImagePriceUsecase: any FetchPlaylistImagePriceUsecase { get }
}

public final class ThumbnailPopupComponent: Component<ThumbnailPopupDependency>, ThumbnailPopupFactory {
    public func makeView(delegate: any ThumbnailPopupDelegate) -> UIViewController {
        ThumbnailPopupViewController(
            reactor: ThumbnailPopupReactor(fetchPlaylistImagePriceUsecase: dependency.fetchPlaylistImagePriceUsecase),
            delegate: delegate
        )
    }
}
