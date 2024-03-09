import Foundation
import NeedleFoundation

public protocol BottomTabBarDependency: Dependency {}

public final class BottomTabBarComponent: Component<BottomTabBarDependency> {
    public func makeView() -> BottomTabBarViewController {
        return BottomTabBarViewController.viewController()
    }
}
