import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import PriceDomainInterface
import UIKit

public protocol PlaylistCoverOptionPopupDependency: Dependency {
    var fetchPlaylistImagePriceUseCase: any FetchPlaylistImagePriceUseCase { get }
}

public final class PlaylistCoverOptionPopupComponent: Component<PlaylistCoverOptionPopupDependency>,
    PlaylistCoverOptionPopupFactory {
    public func makeView(delegate: any PlaylistCoverOptionPopupDelegate) -> UIViewController {
        PlaylistCoverOptionPopupViewController(
            reactor: PlaylistCoverOptionPopupReactor(
                fetchPlaylistImagePriceUsecase: dependency
                    .fetchPlaylistImagePriceUseCase
            ),
            delegate: delegate
        )
    }
}
