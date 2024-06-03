import Foundation
import NeedleFoundation
import PlayerFeature
import PlaylistFeatureInterface
import UIKit
import BaseFeature

public protocol MainContainerDependency: Dependency {
    var bottomTabBarComponent: BottomTabBarComponent { get }
    var mainTabBarComponent: MainTabBarComponent { get }
    var playerComponent: PlayerComponent { get }
    var playlistFactory: any PlaylistFactory { get }
    var playlistPresenterGlobalState: PlayListPresenterGlobalStateProtocol { get }
}

public final class MainContainerComponent: Component<MainContainerDependency> {
    public func makeView() -> MainContainerViewController {
        return MainContainerViewController
            .viewController(
                bottomTabBarComponent: self.dependency.bottomTabBarComponent,
                mainTabBarComponent: self.dependency.mainTabBarComponent,
                playerComponent: self.dependency.playerComponent,
                playlistFactory: self.dependency.playlistFactory,
                playlistPresenterGlobalState: self.dependency.playlistPresenterGlobalState
            )
    }
}
