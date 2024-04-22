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

// import Amplify
// import AWSCognitoAuthPlugin
// import AWSS3StoragePlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Override point for customization after application launch.

        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        setAnalyticsDefaultParameters()
        if let userID = PreferenceManager.userInfo?.ID {
            LogManager.setUserID(userID: AES256.decrypt(encoded: userID))
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

        // Amplify
//        do {
//            try Amplify.add(plugin: AWSCognitoAuthPlugin())
//            try Amplify.add(plugin: AWSS3StoragePlugin())
//            try Amplify.configure()
//            DEBUG_LOG("Amplify configured with Auth and Storage plugins")
//        } catch {
//            DEBUG_LOG("Failed to initialize Amplify with \(error)")
//        }

        // Realm register
        RealmManager.shared.register()

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

    private func setAnalyticsDefaultParameters() {
        let platform = "iOS"
        let os = "iOS \(UIDevice.current.systemVersion)"
        let device = Device().modelName
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "unknown"

        let currentLocale = Locale.current
        let region = if #available(iOS 16.0, *) {
            currentLocale.region?.identifier ?? ""
        } else {
            currentLocale.regionCode ?? "unknown"
        }
        let language = if #available(iOS 16.0, *) {
            currentLocale.language.languageCode?.identifier ?? "unknown"
        } else {
            currentLocale.languageCode ?? "unknown"
        }

        LogManager.setDefaultParameters(params: [
            "platform": platform,
            "os": os,
            "device": device,
            "version": version,
            "region": region,
            "language": language
        ])
    }
}
