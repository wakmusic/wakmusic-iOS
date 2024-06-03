import Inject
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

        let component =
            WakmusicRecommendViewController(reactor: WakmusicRecommendReactor(fetchRecommendPlayListUseCase:))

        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController:)
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
