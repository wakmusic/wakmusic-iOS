import UIKit
import RootFeature
import NaverThirdPartyLogin


@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        application.registerForRemoteNotifications()
        let naverInstance = NaverThirdPartyLoginConnection.getSharedInstance()
        naverInstance?.isNaverAppOauthEnable = true //네이버앱 로그인 설정
        naverInstance?.isInAppOauthEnable = true //사파리 로그인 설정
        naverInstance?.setOnlyPortraitSupportInIphone(true)
        
        naverInstance?.serviceUrlScheme = "waktaverseMusic.naver" //URL Scheme
        naverInstance?.consumerKey = "eSgFVfD8xaTjK8GDRoyu" //클라이언트 아이디
        naverInstance?.consumerSecret = "aRtLNRjqmN" //시크릿 아이디
        naverInstance?.appName = "WAKTAVERSE Music" //앱이름
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
           
            NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
            
    
       
        
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
