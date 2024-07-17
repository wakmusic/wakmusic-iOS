import BaseFeatureInterface
import LyricHighlightingFeatureInterface
import MusicDetailFeatureInterface
import NeedleFoundation
import SongsDomainInterface
@testable import SongsDomainTesting
import UIKit

public protocol MusicDetailDependency: Dependency {
    var fetchSongUseCase: any FetchSongUseCase { get }
    var lyricHighlightingFactory: any LyricHighlightingFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
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
            containSongsFactory: dependency.containSongsFactory
        )

        return UINavigationController(
            rootViewController: viewController
        )
    }
}
