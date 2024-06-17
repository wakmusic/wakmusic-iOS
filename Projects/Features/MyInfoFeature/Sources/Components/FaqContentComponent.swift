import FaqDomainInterface
import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public final class FaqContentComponent: Component<EmptyDependency>, FaqContentFactory {
    public func makeView(dataSource: [FaqModel]) -> UIViewController {
        return FaqContentViewController.viewController(viewModel: .init(dataSource: dataSource))
    }
}
