import Foundation
import NeedleFoundation

public protocol BottomTabBarDependency: Dependency {}

@MainActor
public final class BottomTabBarComponent: Component<BottomTabBarDependency> {
    public func makeView() -> BottomTabBarViewController {
        return BottomTabBarViewController.viewController()
    }
}
