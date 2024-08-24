import BaseFeatureInterface
import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public protocol QuestionDependency: Dependency {
    var textPopupFactory: any TextPopupFactory { get }
}

public final class QuestionComponent: Component<QuestionDependency>, QuestionFactory {
    public func makeView() -> UIViewController {
        return QuestionViewController.viewController(
            viewModel: .init(),
            textPopupFactory: dependency.textPopupFactory
        )
    }
}
