import UIKit
import MainTabFeature
import NeedleFoundation

public protocol RootDependency: Dependency {
    var mainContainerComponent: MainContainerComponent { get }
}

public final class RootComponent: Component<RootDependency> {
    public func makeView() -> IntroViewController {
        return IntroViewController
            .viewController(component: self.dependency.mainContainerComponent)
    }
}
