import UIKit
import RootFeature
import NaverThirdPartyLogin
import AVKit
import Utility
import FirebaseCore
import FirebaseAnalytics
import FirebaseCrashlytics
import RealmSwift
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)

        // configure NaverThirdPartyLoginConnection
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        naverInstance?.isNaverAppOauthEnable = true //네이버앱 로그인 설정
        naverInstance?.isInAppOauthEnable = true //사파리 로그인 설정
        naverInstance?.setOnlyPortraitSupportInIphone(true)
        
        naverInstance?.serviceUrlScheme = NAVER_URL_SCHEME() //URL Scheme
        naverInstance?.consumerKey = NAVER_CONSUMER_KEY() //클라이언트 아이디
        naverInstance?.consumerSecret = NAVER_CONSUMER_SECRET() //시크릿 아이디
        naverInstance?.appName = NAVER_APP_NAME() //앱이름

        do {
                try Amplify.add(plugin: AWSCognitoAuthPlugin())
                try Amplify.add(plugin: AWSS3StoragePlugin())
                try Amplify.configure()
                print("Amplify configured with Auth and Storage plugins")
            } catch {
                print("Failed to initialize Amplify with \(error)")
            }
        
        //Realm register
        RealmManager.shared.register()
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback)
        } catch let error {
            DEBUG_LOG(error.localizedDescription)
        }
        
        
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
    ) {

    }
    

}
