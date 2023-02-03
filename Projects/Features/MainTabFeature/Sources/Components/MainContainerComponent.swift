import Foundation
import UIKit
import PlayerFeature
import NeedleFoundation

public protocol MainContainerDependency: Dependency {
    
}

public final class MainContainerComponent: Component<MainContainerDependency> {
    public func makeView() -> MainContainerViewController {
        return MainContainerViewController.viewController()
    }
}
