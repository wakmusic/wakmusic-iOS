//
//  AppDelegate.swift
//  WaktaverseMusic
//
//  Created by yongbeomkwak on 2022/11/05.
//

import UIKit

@_exported import WaktaverseMusicFramework

let aGate = UIApplication.shared.delegate as! AppDelegate

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var rootController: RootViewController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

extension AppDelegate {

    func rootManager() -> RootViewController {
        if rootController == nil {
            let storyboard = UIStoryboard(name: "Root", bundle: nil)
            rootController = storyboard.instantiateViewController(withIdentifier: "RootViewController") as! RootViewController
        }

        return rootController!
    }
}
