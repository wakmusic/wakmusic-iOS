import UIKit
import RootFeature
import Utility
import NaverThirdPartyLogin


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
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        let scheme: String = url.scheme ?? ""
        DEBUG_LOG("[openURLContexts] scheme: \(scheme), URL: \(url.absoluteString)")
        
        switch scheme {
        case REDIRECT_URI(): //구글
            GoogleLoginManager.shared.getGoogleToken(url)

        case "waktaverseMusic.naver": //네이버
            NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            
        default: return
        }
    }
}
