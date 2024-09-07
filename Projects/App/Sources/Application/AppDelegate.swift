import AVKit
import BaseFeature
import FirebaseAnalytics
import FirebaseCore
import FirebaseCrashlytics
import FirebaseMessaging
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
        initializeUserProperty()

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

extension AppDelegate {
    /// [START receive_message]
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any]
    ) async -> UIBackgroundFetchResult {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.

        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)

        // Print full message.
        LogManager.printDebug("🔔:: \(userInfo)")

        return UIBackgroundFetchResult.newData
    }

    // [END receive_message]

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        LogManager.printDebug("🔔:: Unable to register for remote notifications: \(error.localizedDescription)")
    }

    /// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
    /// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
    /// the FCM registration token.
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        LogManager.printDebug("🔔:: APNs token retrieved: \(token)")

        // With swizzling disabled you must set the APNs token here.
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().token { token, error in
            if let error = error {
                LogManager.printError("🔔:: Messaging.messaging().token: \(error.localizedDescription)")
            } else if let token = token {
                LogManager.printDebug("🔔:: Messaging.messaging().token: \(token)")
            }
        }
    }

    private func initializeUserProperty() {
        if let loginPlatform = PreferenceManager.userInfo?.platform {
            LogManager.setUserProperty(property: .loginPlatform(platform: loginPlatform))
        } else {
            LogManager.clearUserProperty(property: .loginPlatform(platform: ""))
        }

        if let fruitTotal = PreferenceManager.userInfo?.itemCount {
            LogManager.setUserProperty(property: .fruitTotal(count: fruitTotal))
        } else {
            LogManager.clearUserProperty(property: .fruitTotal(count: -1))
        }

        if let playPlatform = PreferenceManager.songPlayPlatformType {
            LogManager.setUserProperty(property: .songPlayPlatform(platform: playPlatform.display))
        }

        LogManager.setUserProperty(property: .playlistSongTotal(count: PlayState.shared.count))
    }
}

#if DEBUG || QA
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
