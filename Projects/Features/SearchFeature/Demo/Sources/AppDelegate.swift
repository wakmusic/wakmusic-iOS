import Inject
@testable import PlaylistDomainTesting
@testable import PlaylistFeatureTesting
@testable import SearchFeature
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let fetchPlayListUseCase: FetchPlayListUseCaseStub = .init()

//        let wakMucomponent =
//            WakmusicRecommendViewController(
//                playlistDetailFactory: PlaylistDetailFactoryStub(),
//                reactor: WakmusicRecommendReactor(fetchRecommendPlaylistUseCase: fetchPlayListUseCase)
//            )

//        let component = SongSearchResultViewController(reactor: SongSearchResultReactor("1234"))
//        let component2 = ListSearchResultViewController(reactor: ListSearchResultReactor("text"))

        let component = SearchSortOptionViewController(selectedModel: .latest)

        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: component)
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
