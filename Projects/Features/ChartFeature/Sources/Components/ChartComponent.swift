import Foundation
import NeedleFoundation

public protocol ChartDependency: Dependency {
    var chartContentComponent: ChartContentComponent { get }
}

public final class ChartComponent: Component<ChartDependency> {
    public func makeView() -> ChartViewController {
        return ChartViewController.viewController(
            chartContentComponent: dependency.chartContentComponent
        )
    }
}
