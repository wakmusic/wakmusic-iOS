import Foundation
import NeedleFoundation
import PlayerFeature
import UIKit

public protocol MainContainerDependency: Dependency {
    var bottomTabBarComponent: BottomTabBarComponent { get }
    var mainTabBarComponent: MainTabBarComponent { get }
    var playerComponent: PlayerComponent { get }
}

public final class MainContainerComponent: Component<MainContainerDependency> {
    public func makeView() -> MainContainerViewController {
        return MainContainerViewController
            .viewController(
                bottomTabBarComponent: self.dependency.bottomTabBarComponent,
                mainTabBarComponent: self.dependency.mainTabBarComponent,
                playerComponent: self.dependency.playerComponent
            )
    }
}
