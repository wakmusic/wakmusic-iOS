import Foundation
import SearchFeature
import NeedleFoundation

public protocol MainTabBarDependency: Dependency {
    var searchComponent:SearchComponent { get }
}

public final class MainTabBarComponent: Component<MainTabBarDependency> {
    public func makeView() -> MainTabBarViewController {
        return MainTabBarViewController.viewController(
            searchComponent:  self.dependency.searchComponent
        )
    }
}
