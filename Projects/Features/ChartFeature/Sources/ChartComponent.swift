import Foundation
import Foundation
import NeedleFoundation

public protocol ChartDependency: Dependency {
    
}

public final class ChartComponent: Component<ChartDependency> {
    public func makeView() -> ChartViewController {
        return ChartViewController.viewController()
    }
}
