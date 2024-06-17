import BaseFeatureInterface
import Foundation
import NeedleFoundation
import MyInfoFeatureInterface
import UIKit

public protocol QuestionDependency: Dependency {
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class QuestionComponent: Component<QuestionDependency>, QuestionFactory {
    public func makeView() -> UIViewController {
        return QuestionViewController.viewController(
            viewModel: .init(),
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
