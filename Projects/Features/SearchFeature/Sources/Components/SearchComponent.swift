import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import UIKit

public protocol SearchDependency: Dependency {
    var beforeSearchComponent: BeforeSearchComponent { get }
    var afterSearchComponent: AfterSearchComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol { get }
}

public final class SearchComponent: Component<SearchDependency>, SearchFactory {
    public func makeView() -> UIViewController {
        return SearchViewController.viewController(
            reactor: SearchReactor(),
            beforeSearchComponent: self.dependency.beforeSearchComponent,
            afterSearchComponent: self.dependency.afterSearchComponent,
            textPopUpFactory: dependency.textPopUpFactory,
            searchGlobalScrollState: dependency.searchGlobalScrollState
        )
    }
}
