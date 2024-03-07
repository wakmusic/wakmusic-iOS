import Combine
import CommonFeature
import NaverThirdPartyLogin
import RootFeature
import UIKit
import Utility

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

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    private var statePublisher: AnyCancellable?

    func sceneWillEnterForeground(_ scene: UIScene) {
        statePublisher?.cancel()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        let isPlayed = PlayState.shared.state
        statePublisher = PlayState.shared.$state.sink { state in
            if state == .paused {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if isPlayed == .playing { PlayState.shared.play() }
                }
            }
        }
    }

    // MARK: - Handling DeepLink
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        let scheme: String = url.scheme ?? ""
        DEBUG_LOG("[openURLContexts] scheme: \(scheme), URL: \(url.absoluteString)")

        switch scheme {
        case GOOGLE_URL_SCHEME(): // 구글
            GoogleLoginManager.shared.getGoogleToken(url)

        case NAVER_URL_SCHEME(): // 네이버
            NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)

        default: return
        }
    }

    // MARK: - Handling UniversalLink
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let webpageURL = userActivity.webpageURL else {
            return
        }
        DEBUG_LOG(webpageURL.absoluteString)
    }
}
