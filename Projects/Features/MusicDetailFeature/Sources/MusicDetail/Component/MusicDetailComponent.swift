import BaseFeature
import BaseFeatureInterface
import LikeDomainInterface
import LyricHighlightingFeatureInterface
import MusicDetailFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import SongCreditFeatureInterface
import SongsDomainInterface
import UIKit

public protocol MusicDetailDependency: Dependency {
    var fetchSongUseCase: any FetchSongUseCase { get }
    var lyricHighlightingFactory: any LyricHighlightingFactory { get }
    var songCreditFactory: any SongCreditFactory { get }
    var signInFactory: any SignInFactory { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var karaokeFactory: any KaraokeFactory { get }
    var textPopupFactory: any TextPopupFactory { get }
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol { get }
    var addLikeSongUseCase: any AddLikeSongUseCase { get }
    var cancelLikeSongUseCase: any CancelLikeSongUseCase { get }
}

public final class MusicDetailComponent: Component<MusicDetailDependency>, MusicDetailFactory {
    public func makeViewController(songIDs: [String], selectedID: String) -> UIViewController {
        let reactor = MusicDetailReactor(
            songIDs: songIDs,
            selectedID: selectedID,
            fetchSongUseCase: dependency.fetchSongUseCase,
            addLikeSongUseCase: dependency.addLikeSongUseCase,
            cancelLikeSongUseCase: dependency.cancelLikeSongUseCase
        )

        let viewController = MusicDetailViewController(
            reactor: reactor,
            lyricHighlightingFactory: dependency.lyricHighlightingFactory,
            songCreditFactory: dependency.songCreditFactory,
            signInFactory: dependency.signInFactory,
            containSongsFactory: dependency.containSongsFactory,
            textPopupFactory: dependency.textPopupFactory,
            karaokeFactory: dependency.karaokeFactory,
            playlistPresenterGlobalState: dependency.playlistPresenterGlobalState
        )

        return UINavigationController(
            rootViewController: viewController
        )
    }
}
