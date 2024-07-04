import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import UIKit

public protocol WakmusicPlaylistDetailDependency: Dependency {
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase { get }

    var containSongsFactory: any ContainSongsFactory { get }

    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class WakmusicPlaylistDetailComponent: Component<WakmusicPlaylistDetailDependency>,
    WakmusicPlaylistDetailFactory {
    public func makeView(key: String) -> UIViewController {
        return WakmusicPlaylistDetailViewController(
            reactor: WakmusicPlaylistDetailReactor(
                key: key,
                fetchPlaylistDetailUseCase: dependency.fetchPlaylistDetailUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}