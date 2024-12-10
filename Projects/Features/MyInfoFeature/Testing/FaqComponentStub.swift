import FaqDomainInterface
@testable import FaqDomainTesting
import Foundation
@testable import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class FaqComponentStub: FaqFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return FaqViewController.viewController(
            viewModel: .init(
                fetchFaqCategoriesUseCase: FetchFaqCategoriesUseCaseStub(),
                fetchQnaUseCase: FetchFaqUseCaseStub()
            ),
            faqContentFactory: FaqContentComponentStub()
        )
    }
}
