import AuthDomainInterface
import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistDomainInterface
import PlaylistFeatureInterface
import SignInFeatureInterface
import UIKit

public protocol UnknownPlaylistDetailDependency: Dependency {
    var fetchPlaylistDetailUseCase: any FetchPlaylistDetailUseCase { get }
    var subscribePlaylistUseCase: any SubscribePlaylistUseCase { get }
    var checkSubscriptionUseCase: any CheckSubscriptionUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var songDetailPresenter: any SongDetailPresentable { get }

    var signInFactory: any SignInFactory { get }
}

public final class UnknownPlaylistDetailComponent: Component<UnknownPlaylistDetailDependency>,
    UnknownPlaylistDetailFactory {
    public func makeView(key: String) -> UIViewController {
        return UnknownPlaylistDetailViewController(
            reactor: UnknownPlaylistDetailReactor(
                key: key,
                fetchPlaylistDetailUseCase: dependency.fetchPlaylistDetailUseCase,
                subscribePlaylistUseCase: dependency.subscribePlaylistUseCase,
                checkSubscriptionUseCase: dependency.checkSubscriptionUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            containSongsFactory: dependency.containSongsFactory,
            songDetailPresenter: dependency.songDetailPresenter,
            signInFactory: dependency.signInFactory
        )
    }
}
