import Foundation
import DomainModule
import NeedleFoundation

public protocol PlayerDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
    var addLikeSongUseCase: any AddLikeSongUseCase {get }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase { get }
    var fetchLikeNumOfSongUseCase: any FetchLikeNumOfSongUseCase { get }
    var playlistComponent: PlaylistComponent { get }
}

public final class PlayerComponent: Component<PlayerDependency> {
    public func makeView() -> PlayerViewController {
        return PlayerViewController(
            viewModel: .init(
                fetchLyricsUseCase: dependency.fetchLyricsUseCase,
                addLikeSongUseCase: dependency.addLikeSongUseCase,
                cancelLikeSongUseCase: dependency.cancelLikeSongUseCase,
                fetchLikeNumOfSongUseCase: dependency.fetchLikeNumOfSongUseCase
            ),
            playlistComponent: dependency.playlistComponent
        )
    }
}
