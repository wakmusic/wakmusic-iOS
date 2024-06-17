import Inject
@testable import MyInfoFeatureTesting
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)

        let vc = MyInfoComponentStub()
        let viewController = Inject.ViewControllerHost(
            UINavigationController(rootViewController: vc.makeView())
        )
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        return true
    }
}
