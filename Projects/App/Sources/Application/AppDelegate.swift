import UIKit
import RootFeature
import NaverThirdPartyLogin
import AVKit
import Utility
import FirebaseCore

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Use Firebase library to configure APIs
        FirebaseApp.configure()

        // configure NaverThirdPartyLoginConnection
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        naverInstance?.isNaverAppOauthEnable = true //네이버앱 로그인 설정
        naverInstance?.isInAppOauthEnable = true //사파리 로그인 설정
        naverInstance?.setOnlyPortraitSupportInIphone(true)
        
        naverInstance?.serviceUrlScheme = "waktaverseMusic.naver" //URL Scheme
        naverInstance?.consumerKey = "eSgFVfD8xaTjK8GDRoyu" //클라이언트 아이디
        naverInstance?.consumerSecret = "aRtLNRjqmN" //시크릿 아이디
        naverInstance?.appName = "WAKTAVERSE Music" //앱이름
        
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
