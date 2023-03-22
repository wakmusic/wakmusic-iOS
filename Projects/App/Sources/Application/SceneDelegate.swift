import UIKit
import RootFeature

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        registerProviderFactories()
        let root = AppComponent()
        self.window?.rootViewController = root.makeRootView().wrapNavigationController
        self.window?.makeKeyAndVisible()
    }
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            print("URLContexts: \(url)")
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }
    func sceneDidBecomeActive(_ scene: UIScene) {

    }
    func sceneWillResignActive(_ scene: UIScene) {

    }
    func sceneWillEnterForeground(_ scene: UIScene) {

    }
    func sceneDidEnterBackground(_ scene: UIScene) {

    }
}
