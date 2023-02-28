import Foundation
import UIKit
import NeedleFoundation
import PlayerFeature
import RootFeature
import MainTabFeature
import KeychainModule

public final class AppComponent: BootstrapComponent {
    public func makeRootView() -> IntroViewController {
        rootComponent.makeView()
    }

    public var keychain: any Keychain {
        shared {
            KeychainImpl()
        }
    }

    var rootComponent: RootComponent {
        shared {
            RootComponent(parent: self)
        }
    }

}

// MARK: - Tabbar
public extension AppComponent {
    var mainContainerComponent: MainContainerComponent {
        MainContainerComponent(parent: self)
    }
    
    var bottomTabBarComponent: BottomTabBarComponent {
        BottomTabBarComponent(parent: self)
    }

    var mainTabBarComponent: MainTabBarComponent {
        MainTabBarComponent(parent: self)
    }
}

// MARK: - Player
public extension AppComponent {
    var playerComponent: PlayerComponent {
        PlayerComponent(parent: self)
    }
    
    var playlistComponent: PlaylistComponent {
        PlaylistComponent(parent: self)
    }
}
