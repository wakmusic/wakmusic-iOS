import Foundation
import CommonFeature
import NeedleFoundation
import DomainModule


public protocol ChartDependency: Dependency {
    var chartContentComponent: ChartContentComponent { get }
    
}

public final class ChartComponent: Component<ChartDependency> {
    public func makeView() -> ChartViewController {
        return ChartViewController.viewController(chartContentComponent: dependency.chartContentComponent)
    }
}
