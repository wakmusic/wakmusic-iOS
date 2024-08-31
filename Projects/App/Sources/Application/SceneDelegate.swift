import BaseFeature
import Combine
import LogManager
import NaverThirdPartyLogin
import RootFeature
import UIKit
import Utility

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private var root: AppComponent?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: scene)
        registerProviderFactories()
        self.root = AppComponent()
        self.window?.rootViewController = root?.makeRootView().wrapNavigationController
        self.window?.makeKeyAndVisible()

        // Handling App Entry:: Not Running State
        handleAppEntry(with: connectionOptions)
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}

    // MARK: - Handling DeepLink
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }

        let scheme: String = url.scheme ?? ""
        LogManager.printDebug("[openURLContexts] scheme: \(scheme), URL: \(url.absoluteString)")

        switch scheme {
        case GOOGLE_URL_SCHEME(): // 구글
            GoogleLoginManager.shared.getGoogleToken(url)

        case NAVER_URL_SCHEME(): // 네이버
            NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)

        case WM_URI_SCHEME():
            handleDeeplink(url: url)

        default: return
        }
    }

    // MARK: - Handling UniversalLink
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let webpageURL = userActivity.webpageURL else {
            return
        }
        LogManager.printDebug("URL: \(webpageURL.absoluteString)")

        guard webpageURL.host == WM_UNIVERSALLINK_DOMAIN() else {
            return
        }
        handleUniversalLink(url: webpageURL)
    }
}

private extension SceneDelegate {
    func handleAppEntry(with connectionOptions: UIScene.ConnectionOptions) {
        if let url = connectionOptions.urlContexts.first?.url {
            handleDeeplink(url: url)

        } else if let userActivity = connectionOptions.userActivities.first,
                  userActivity.activityType == NSUserActivityTypeBrowsingWeb,
                  let webpageURL = userActivity.webpageURL {
            handleUniversalLink(url: webpageURL)

        } else if let notification = connectionOptions.notificationResponse?.notification {
            let userInfo = notification.request.content.userInfo
            root?.appEntryState.moveScene(params: userInfo.parseNotificationInfo)
        }
    }

    func handleDeeplink(url: URL) {
        let page: String = url.host ?? ""
        let pathComponents: [String] = url.pathComponents.filter { $0 != "/" }
        var params: [String: Any] = url.parseToParams()
        params["page"] = page
        LogManager.printDebug("host: \(page), pathComponents: \(pathComponents), params: \(params)")
        root?.appEntryState.moveScene(params: params)
    }

    func handleUniversalLink(url: URL) {
        let host: String = url.host ?? ""
        let pathComponents: [String] = url.pathComponents.filter { $0 != "/" }
        let page: String = pathComponents.first ?? ""
        let key: String = pathComponents.last ?? ""
        var params: [String: Any] = url.parseToParams()
        params["page"] = page
        params["key"] = key
        LogManager.printDebug("host: \(host), pathComponents: \(pathComponents), params: \(params)")
        root?.appEntryState.moveScene(params: params)
    }
}
