import CommonFeature
import DomainModule
import Foundation
import NeedleFoundation

public protocol PlayerDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
    var addLikeSongUseCase: any AddLikeSongUseCase { get }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase { get }
    var fetchLikeNumOfSongUseCase: any FetchLikeNumOfSongUseCase { get }
    var fetchFavoriteSongsUseCase: any FetchFavoriteSongsUseCase { get }
    var postPlaybackLogUseCase: any PostPlaybackLogUseCase { get }
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
                postPlaybackLogUseCase: dependency.postPlaybackLogUseCase
            ),
            playlistComponent: dependency.playlistComponent,
            containSongsComponent: dependency.containSongsComponent
        )
    }
}
