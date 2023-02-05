import Foundation
import NeedleFoundation

public protocol PlayerDependency: Dependency {
    
}

public final class PlayerComponent: Component<PlayerDependency> {
    public func makeView() -> PlayerViewController {
        return PlayerViewController()
    }
}
