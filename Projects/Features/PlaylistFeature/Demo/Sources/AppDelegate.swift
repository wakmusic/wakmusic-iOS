@testable import BaseFeature
import Inject
@testable import PlaylistFeature
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let viewController = Inject.ViewControllerHost(
            UINavigationController(
                rootViewController: UIViewController()
            )
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
