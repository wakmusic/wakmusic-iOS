@testable import ArtistDomainTesting
import ArtistFeatureInterface
import BaseFeature
import BaseFeatureInterface
import Inject
import LikeDomainInterface
import LikeDomainTesting
import LyricHighlightingFeatureInterface
@testable import MusicDetailFeature
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

final class DummyLyricHighlightingFactory: LyricHighlightingFactory, @unchecked Sendable {
    func makeView(model: LyricHighlightingRequiredModel) -> UIViewController {
        return UIViewController()
    }
}

final class DummyContainSongsFactory: ContainSongsFactory, @unchecked Sendable {
    func makeView(songs: [String]) -> UIViewController {
        return UIViewController()
    }
}

final class DummySongCreditFactory: SongCreditFactory, @unchecked Sendable {
    func makeViewController(songID: String) -> UIViewController {
        return UIViewController()
    }
}

final class DummySignInFactory: SignInFactory, @unchecked Sendable {
    func makeView() -> UIViewController {
        return UIViewController()
    }
}

final class DummyTextPopupFactory: TextPopupFactory, @unchecked Sendable {
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

final class DummyPlaylistPresenterGlobalState: PlayListPresenterGlobalStateProtocol, @unchecked Sendable {
    var presentPlayListObservable: RxSwift.Observable<String?> { .empty() }
    func presentPlayList(currentSongID: String?) {}
    func presentPlayList() {}
}

final class DummyKaraokeFactory: KaraokeFactory, @unchecked Sendable {
    func makeViewController(ky: Int?, tj: Int?) -> UIViewController {
        UIViewController()
    }
}

final class DummyArtistDetailFactory: ArtistDetailFactory, @unchecked Sendable {
    func makeView(artistID: String) -> UIViewController {
        UIViewController()
    }
}
