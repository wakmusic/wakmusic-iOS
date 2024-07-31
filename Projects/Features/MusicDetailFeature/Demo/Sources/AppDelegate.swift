import BaseFeature
import BaseFeatureInterface
import Inject
import LikeDomainInterface
@testable import MusicDetailFeature
import LikeDomainTesting
import LyricHighlightingFeatureInterface
import RxSwift
import SongCreditFeatureInterface
import SongsDomainTesting
import UIKit
import Utility

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let fetchSongUseCase = FetchSongUseCaseSpy()
        fetchSongUseCase.handler = { _ in
            .just(
                .init(
                    id: "DPEtmqvaKqY",
                    title: "팬서비스",
                    artist: "고세구",
                    views: 120,
                    date: "2024.03.11",
                    likes: 120,
                    karaokeNumber: .init(TJ: 36, KY: nil)
                )
            )
        }
        let checkIsLikedSongUseCase = CheckIsLikedSongUseCaseSpy()
        checkIsLikedSongUseCase.handler = { _ in
            Single.just(true)
        }

        let addLikeSongUseCase = AddLikeSongUseCaseSpy()
        addLikeSongUseCase.handler = { _ in
            .just(.init(status: "", likes: 0))
        }
        let cancelLikeSongUseCase = CancelLikeSongUseCaseSpy()
        cancelLikeSongUseCase.handler = { _ in
            .just(.init(status: "", likes: 0))
        }

        let reactor = MusicDetailReactor(
            songIDs: [
                "fgSXAKsq-Vo",
                "DPEtmqvaKqY",
                "KQa297hRop0",
                "qZi1Xh0_8q4"
            ],
            selectedID: "DPEtmqvaKqY",
            fetchSongUseCase: fetchSongUseCase,
            checkIsLikedSongUseCase: checkIsLikedSongUseCase,
            addLikeSongUseCase: addLikeSongUseCase,
            cancelLikeSongUseCase: cancelLikeSongUseCase
        )
        let viewController = Inject.ViewControllerHost(
            UINavigationController(
                rootViewController: MusicDetailViewController(
                    reactor: reactor,
                    lyricHighlightingFactory: DummyLyricHighlightingFactory(),
                    songCreditFactory: DummySongCreditFactory(),
                    containSongsFactory: DummyContainSongsFactory(),
                    playlistPresenterGlobalState: DummyPlaylistPresenterGlobalState()
                )
            )
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

final class DummyLyricHighlightingFactory: LyricHighlightingFactory {
    func makeView(model: LyricHighlightingRequiredModel) -> UIViewController {
        return UIViewController()
    }
}

final class DummyContainSongsFactory: ContainSongsFactory {
    func makeView(songs: [String]) -> UIViewController {
        return UIViewController()
    }
}

final class DummySongCreditFactory: SongCreditFactory {
    func makeViewController(songID: String) -> UIViewController {
        return UIViewController()
    }
}

final class DummyPlaylistPresenterGlobalState: PlayListPresenterGlobalStateProtocol {
    var presentPlayListObservable: RxSwift.Observable<Void> { .empty() }
    func presentPlayList() {}
}
