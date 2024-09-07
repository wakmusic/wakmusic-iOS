import BaseFeature
import ChartFeatureInterface
import Foundation
import NeedleFoundation
import UIKit

public protocol ChartDependency: Dependency {
    var chartContentComponent: ChartContentComponent { get }
}

public final class ChartComponent: Component<ChartDependency>, ChartFactory {
    public func makeView() -> UIViewController {
        return ChartViewController.viewController(chartContentComponent: dependency.chartContentComponent)
    }
}
