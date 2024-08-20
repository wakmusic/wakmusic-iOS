import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit

public protocol WakmusicPlaylistDetailDependency: Dependency {
    var fetchWmPlaylistDetailUseCase: any FetchWmPlaylistDetailUseCase { get }
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
                fetchWmPlaylistDetailUseCase: dependency.fetchWmPlaylistDetailUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            textPopUpFactory: dependency.textPopUpFactory,
            songDetailPresenter: dependency.songDetailPresenter,
            signInFactory: dependency.signInFactory
        )
    }
}
