import BaseFeatureInterface
import Foundation
import NeedleFoundation

public protocol QuestionDependency: Dependency {
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class QuestionComponent: Component<QuestionDependency> {
    public func makeView() -> QuestionViewController {
        return QuestionViewController.viewController(
            viewModel: .init(),
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
