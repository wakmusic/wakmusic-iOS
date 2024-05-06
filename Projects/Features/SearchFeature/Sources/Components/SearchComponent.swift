import BaseFeatureInterface
import UIKit
import Foundation
import NeedleFoundation
import SearchFeatureInterface

public protocol SearchDependency: Dependency {
    var beforeSearchComponent: BeforeSearchComponent { get }
    var afterSearchComponent: AfterSearchComponent { get }
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class SearchComponent: Component<SearchDependency>, SearchFactory {
    public func makeView() -> UIViewController {
        return SearchViewController.viewController(
            reactor: SearchReactor(),
            beforeSearchComponent: self.dependency.beforeSearchComponent,
            afterSearchComponent: self.dependency.afterSearchComponent,
            textPopUpFactory: dependency.textPopUpFactory
        )
    }
}
