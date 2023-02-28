import Foundation
import DomainModule
import NeedleFoundation

public protocol PlayerDependency: Dependency {
    var fetchLyricsUseCase: any FetchLyricsUseCase { get }
    var playlistComponent: PlaylistComponent { get }
}

public final class PlayerComponent: Component<PlayerDependency> {
    public func makeView() -> PlayerViewController {
        return PlayerViewController(viewModel: .init(fetchLyricsUseCase: dependency.fetchLyricsUseCase),
                                    playlistComponent: dependency.playlistComponent)
    }
}
