import UIKit
import RootFeature
import Utility
import NaverThirdPartyLogin
import CommonFeature

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
        let allPlayedLists = RealmManager.shared.realm.objects(PlayedLists.self)
        RealmManager.shared.deleteRealmDB(model: allPlayedLists)
        
        let playedList =  PlayState.shared.playList.list.map {
            PlayedLists(
                id: $0.item.id,
                title: $0.item.title,
                artist: $0.item.artist,
                remix: $0.item.remix,
                reaction: $0.item.reaction,
                views: $0.item.views,
                last: $0.item.last,
                date: $0.item.date
            )}
        RealmManager.shared.addRealmDB(model: playedList)
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        
        let scheme: String = url.scheme ?? ""
        DEBUG_LOG("[openURLContexts] scheme: \(scheme), URL: \(url.absoluteString)")
        
        switch scheme {
        case GOOGLE_URL_SCHEME(): //구글
            GoogleLoginManager.shared.getGoogleToken(url)

        case NAVER_URL_SCHEME(): //네이버
            NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
            
        default: return
        }
    }
}
