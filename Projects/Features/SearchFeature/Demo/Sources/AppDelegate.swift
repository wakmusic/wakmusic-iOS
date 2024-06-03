import Inject
@testable import PlayListDomainTesting
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

        let fetchPlayListUseCase: FetchPlayListUseCaseSpy = .init()

        let component =
            WakmusicRecommendViewController(
                reactor: WakmusicRecommendReactor(fetchRecommendPlayListUseCase: fetchPlayListUseCase)
            )

        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: component)
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
