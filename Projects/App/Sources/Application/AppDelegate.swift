import AVKit
import BaseFeature
import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import LogManager
import NaverThirdPartyLogin
import RealmSwift
import RootFeature
import UIKit
import Utility

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        if let userInfo = PreferenceManager.userInfo {
            LogManager.setUserID(userID: userInfo.decryptedID)
        } else {
            LogManager.setUserID(userID: nil)
        }

        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)

        // configure NaverThirdPartyLoginConnection
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        naverInstance?.isNaverAppOauthEnable = true // 네이버앱 로그인 설정
        naverInstance?.isInAppOauthEnable = true // 사파리 로그인 설정
        naverInstance?.setOnlyPortraitSupportInIphone(true)

        naverInstance?.serviceUrlScheme = NAVER_URL_SCHEME() // URL Scheme
        naverInstance?.consumerKey = NAVER_CONSUMER_KEY() // 클라이언트 아이디
        naverInstance?.consumerSecret = NAVER_CONSUMER_SECRET() // 시크릿 아이디
        naverInstance?.appName = NAVER_APP_NAME() // 앱이름

        // 테스트코드
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}

#if DEBUG
    extension UIWindow {
        override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
            super.motionEnded(motion, with: event)
            switch motion {
            case .motionShake:
                let topViewController = UIApplication.shared.connectedScenes
                    .compactMap { $0 as? UIWindowScene }
                    .filter { $0.activationState == .foregroundActive }
                    .first?
                    .keyWindow?
                    .rootViewController
                guard let topViewController else { break }
                let logHistoryViewController = UINavigationController(rootViewController: LogHistoryViewController())
                if let nav = topViewController as? UINavigationController,
                   !(nav.visibleViewController is LogHistoryViewController) {
                    nav.visibleViewController?.present(logHistoryViewController, animated: true)
                } else if !(topViewController is LogHistoryViewController) {
                    topViewController.present(logHistoryViewController, animated: true)
                }

            default:
                break
            }
        }
    }
#endif
