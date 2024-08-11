import ArtistFeatureInterface
import CreditSongListFeatureInterface
import RxSwift
@testable import SongCreditFeature
import SongsDomainInterface
import SongsDomainTesting
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let fetchSongCreditsUseCase = FetchSongCreditsUseCaseSpy()
        fetchSongCreditsUseCase.handler = { _ in
            Single.just([
                SongCreditsEntity(
                    type: "보컬",
                    names: ["a", "ab", "abc"]
                ),
                SongCreditsEntity(
                    type: "피처링",
                    names: ["ab", "abc", "dabc", "fdzz", "대충 긴 텍스트", "텍스트"]
                )
            ])
        }
        let reactor = SongCreditReactor(
            songID: "DPEtmqvaKqY",
            fetchSongCreditsUseCase: fetchSongCreditsUseCase
        )
        let viewController = SongCreditViewController(
            reactor: reactor,
            creditSongListFactory: DummyCreditSongListFactory(),
            artistDetailFactory: DummyArtistDetailFactory()
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}

final class DummyCreditSongListFactory: CreditSongListFactory {
    func makeViewController(workerName: String) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }
}

final class DummyArtistDetailFactory: ArtistDetailFactory {
    func makeView(artistID: String) -> UIViewController {
        return UIViewController()
    }
}
