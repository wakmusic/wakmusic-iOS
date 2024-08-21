import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit

public protocol WakmusicPlaylistDetailDependency: Dependency {
    var fetchWMPlaylistDetailUseCase: any FetchWMPlaylistDetailUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }
    var signInFactory: any SignInFactory { get }
}

public final class WakmusicPlaylistDetailComponent: Component<WakmusicPlaylistDetailDependency>,
    WakmusicPlaylistDetailFactory {
    public func makeView(key: String) -> UIViewController {
        return WakmusicPlaylistDetailViewController(
            reactor: WakmusicPlaylistDetailReactor(
                key: key,
                fetchWMPlaylistDetailUseCase: dependency.fetchWMPlaylistDetailUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            songDetailPresenter: dependency.songDetailPresenter,
            signInFactory: dependency.signInFactory
        )
    }
}
