import BaseFeatureInterface
@testable import BaseFeatureTesting
@testable import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class QuestionComponentStub: QuestionFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return QuestionViewController.viewController(
            viewModel: .init(),
            textPopupFactory: TextPopupComponentStub()
        )
    }
}
