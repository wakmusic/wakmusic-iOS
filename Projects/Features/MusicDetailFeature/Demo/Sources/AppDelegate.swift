import Inject
import LyricHighlightingFeatureInterface
@testable import MusicDetailFeature
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
                    remix: "",
                    reaction: "",
                    views: 120,
                    last: 0,
                    date: "2024.03.11",
                    likes: 120,
                    karaokeNumber: .init(TJ: 36, KY: nil)
                )
            )
        }

        let reactor = MusicDetailReactor(
            songIDs: [
                "fgSXAKsq-Vo",
                "DPEtmqvaKqY",
                "KQa297hRop0",
                "qZi1Xh0_8q4"
            ],
            selectedID: "DPEtmqvaKqY",
            fetchSongUseCase: fetchSongUseCase
        )
        let viewController = Inject.ViewControllerHost(
            UINavigationController(
                rootViewController: MusicDetailViewController(
                    reactor: reactor,
                    lyricHighlightingFactory: DummyLyricHighlightingFactory()
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
