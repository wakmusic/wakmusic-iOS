import BaseFeatureInterface
import NeedleFoundation
import UIKit
import SearchDomainInterface


public final class SearchOptionComponent: Component<EmptyDependency> {
    public func makeView(_ sortType: SortType) -> UIViewController {
        return SearchOptionViewController(selectedModel: sortType)
    }
}
