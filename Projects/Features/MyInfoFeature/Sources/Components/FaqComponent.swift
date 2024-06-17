import FaqDomainInterface
import Foundation
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public protocol FaqDependency: Dependency {
    var faqContentComponent: FaqContentComponent { get }
    var fetchFaqCategoriesUseCase: any FetchFaqCategoriesUseCase { get }
    var fetchFaqUseCase: any FetchFaqUseCase { get }
}

public final class FaqComponent: Component<FaqDependency>, FaqFactory {
    public func makeView() -> UIViewController {
        return FaqViewController.viewController(
            viewModel: .init(
                fetchFaqCategoriesUseCase: dependency.fetchFaqCategoriesUseCase,
                fetchQnaUseCase: dependency.fetchFaqUseCase
            ),
            faqContentComponent: dependency.faqContentComponent
        )
    }
}
