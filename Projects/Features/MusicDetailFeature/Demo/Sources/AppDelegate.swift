@testable import ArtistDomainTesting
import ArtistFeatureInterface
import BaseFeature
import BaseFeatureInterface
import Inject
import LikeDomainInterface
@testable import MusicDetailFeature
import LikeDomainTesting
import LyricHighlightingFeatureInterface
import MusicDetailFeatureInterface
import RxSwift
import SignInFeatureInterface
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
                    isLiked: false,
                    karaokeNumber: .init(tj: 36, ky: nil)
                )
            )
        }

        let addLikeSongUseCase = AddLikeSongUseCaseSpy()
        addLikeSongUseCase.handler = { _ in
            .just(.init(status: "", likes: 0))
        }
        let cancelLikeSongUseCase = CancelLikeSongUseCaseSpy()
        cancelLikeSongUseCase.handler = { _ in
            .just(.init(status: "", likes: 0))
        }

        let findArtistIDUseCase = FindArtistIDUseCaseSpy()
        findArtistIDUseCase.handler = { _ in
            .just("fgSXAKsq-Vo")
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
            addLikeSongUseCase: addLikeSongUseCase,
            cancelLikeSongUseCase: cancelLikeSongUseCase,
            findArtistIDUseCase: findArtistIDUseCase
        )
        let viewController = Inject.ViewControllerHost(
            UINavigationController(
                rootViewController: MusicDetailViewController(
                    reactor: reactor,
                    lyricHighlightingFactory: DummyLyricHighlightingFactory(),
                    songCreditFactory: DummySongCreditFactory(),
                    signInFactory: DummySignInFactory(),
                    containSongsFactory: DummyContainSongsFactory(),
                    textPopupFactory: DummyTextPopupFactory(),
                    karaokeFactory: DummyKaraokeFactory(),
                    artistDetailFactory: DummyArtistDetailFactory(),
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

final class DummySignInFactory: SignInFactory {
    func makeView() -> UIViewController {
        return UIViewController()
    }
}

final class DummyTextPopupFactory: TextPopupFactory {
    func makeView(
        text: String?,
        cancelButtonIsHidden: Bool,
        confirmButtonText: String?,
        cancelButtonText: String?,
        completion: (() -> Void)?,
        cancelCompletion: (() -> Void)?
    ) -> UIViewController {
        return UIViewController()
    }
}

final class DummyPlaylistPresenterGlobalState: PlayListPresenterGlobalStateProtocol {
    var presentPlayListObservable: RxSwift.Observable<String?> { .empty() }
    func presentPlayList(currentSongID: String?) {}
    func presentPlayList() {}
}

final class DummyKaraokeFactory: KaraokeFactory {
    func makeViewController(ky: Int?, tj: Int?) -> UIViewController {
        UIViewController()
    }
}

final class DummyArtistDetailFactory: ArtistDetailFactory {
    func makeViewController(artistID: String) -> UIViewController {
        UIViewController()
    }
}
