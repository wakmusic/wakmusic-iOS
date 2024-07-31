import BaseFeature
import BaseFeatureInterface
import LikeDomainInterface
import LyricHighlightingFeatureInterface
import MusicDetailFeatureInterface
import NeedleFoundation
import SongCreditFeatureInterface
import SongsDomainInterface
import UIKit

public protocol MusicDetailDependency: Dependency {
    var fetchSongUseCase: any FetchSongUseCase { get }
    var lyricHighlightingFactory: any LyricHighlightingFactory { get }
    var songCreditFactory: any SongCreditFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol { get }
    var checkIsLikedSongUseCase: any CheckIsLikedSongUseCase { get }
    var addLikeSongUseCase: any AddLikeSongUseCase { get }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase { get }
}

public final class MusicDetailComponent: Component<MusicDetailDependency>, MusicDetailFactory {
    public func makeViewController(songIDs: [String], selectedID: String) -> UIViewController {
        let reactor = MusicDetailReactor(
            songIDs: songIDs,
            selectedID: selectedID,
            fetchSongUseCase: dependency.fetchSongUseCase,
            checkIsLikedSongUseCase: dependency.checkIsLikedSongUseCase,
            addLikeSongUseCase: dependency.addLikeSongUseCase,
            cancelLikeSongUseCase: dependency.cancelLikeSongUseCase
        )

        let viewController = MusicDetailViewController(
            reactor: reactor,
            lyricHighlightingFactory: dependency.lyricHighlightingFactory,
            songCreditFactory: dependency.songCreditFactory,
            containSongsFactory: dependency.containSongsFactory,
            playlistPresenterGlobalState: dependency.playlistPresenterGlobalState
        )

        return UINavigationController(
            rootViewController: viewController
        )
    }
}
