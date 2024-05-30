import Inject
@testable import MyInfoFeature
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let reactor = MyInfoReactor()
        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: MyInfoViewController(reactor: reactor))
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
