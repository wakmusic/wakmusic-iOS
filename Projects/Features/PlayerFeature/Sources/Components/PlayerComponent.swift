import AuthDomainInterface
import BaseFeature
import Foundation
import LikeDomainInterface
import NeedleFoundation
import SongsDomainInterface
import UserDomainInterface

public protocol PlayerDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
    var addLikeSongUseCase: any AddLikeSongUseCase { get }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase { get }
    var fetchLikeNumOfSongUseCase: any FetchLikeNumOfSongUseCase { get }
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
    var playlistComponent: PlaylistComponent { get }
    var containSongsComponent: ContainSongsComponent { get }
}

public final class PlayerComponent: Component<PlayerDependency> {
    public func makeView() -> PlayerViewController {
        return PlayerViewController(
            viewModel: .init(
                fetchLyricsUseCase: dependency.fetchLyricsUseCase,
                addLikeSongUseCase: dependency.addLikeSongUseCase,
                cancelLikeSongUseCase: dependency.cancelLikeSongUseCase,
                fetchLikeNumOfSongUseCase: dependency.fetchLikeNumOfSongUseCase,
                fetchFavoriteSongsUseCase: dependency.fetchFavoriteSongsUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            playlistComponent: dependency.playlistComponent,
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
