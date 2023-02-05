import Foundation
import NeedleFoundation

public protocol MainTabBarDependency: Dependency {
    
}

public final class MainTabBarComponent: Component<MainTabBarDependency> {
    public func makeView() -> MainTabBarViewController {
        return MainTabBarViewController.viewController()
    }
}
