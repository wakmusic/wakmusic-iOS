import BaseFeature
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol MainContainerDependency: Dependency {
    var bottomTabBarComponent: BottomTabBarComponent { get }
    var mainTabBarComponent: MainTabBarComponent { get }
    var playlistFactory: any PlaylistFactory { get }
    var playlistPresenterGlobalState: any PlayListPresenterGlobalStateProtocol { get }
}

@MainActor
public final class MainContainerComponent: Component<MainContainerDependency> {
    public func makeView() -> MainContainerViewController {
        return MainContainerViewController
            .viewController(
                bottomTabBarComponent: self.dependency.bottomTabBarComponent,
                mainTabBarComponent: self.dependency.mainTabBarComponent,
                playlistFactory: self.dependency.playlistFactory,
                playlistPresenterGlobalState: self.dependency.playlistPresenterGlobalState
            )
    }
}
