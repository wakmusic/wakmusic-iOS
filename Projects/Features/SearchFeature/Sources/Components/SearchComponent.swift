import Foundation
import NeedleFoundation
import BaseFeatureInterface

public protocol SearchDependency: Dependency {
    var beforeSearchComponent: BeforeSearchComponent { get }
    var afterSearchComponent: AfterSearchComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class SearchComponent: Component<SearchDependency> {
    public func makeView() -> SearchViewController {
        return SearchViewController.viewController(
            viewModel: .init(),
            beforeSearchComponent: self.dependency.beforeSearchComponent,
            afterSearchComponent: self.dependency.afterSearchComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
