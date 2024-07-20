import BaseFeature
import BaseFeatureInterface
import LyricHighlightingFeatureInterface
import MusicDetailFeatureInterface
import NeedleFoundation
import SongsDomainInterface
import UIKit

public protocol MusicDetailDependency: Dependency {
    var fetchSongUseCase: any FetchSongUseCase { get }
    var lyricHighlightingFactory: any LyricHighlightingFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol { get }
}

public final class MusicDetailComponent: Component<MusicDetailDependency>, MusicDetailFactory {
    public func makeViewController(songIDs: [String], selectedID: String) -> UIViewController {
        let reactor = MusicDetailReactor(
            songIDs: songIDs,
            selectedID: selectedID,
            fetchSongUseCase: dependency.fetchSongUseCase
        )

        let viewController = MusicDetailViewController(
            reactor: reactor,
            lyricHighlightingFactory: dependency.lyricHighlightingFactory,
            containSongsFactory: dependency.containSongsFactory,
            playlistPresenterGlobalState: dependency.playlistPresenterGlobalState
        )

        return UINavigationController(
            rootViewController: viewController
        )
    }
}
