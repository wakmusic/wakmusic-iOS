import BaseFeatureInterface
import NeedleFoundation
import SearchDomainInterface
import UIKit

@MainActor
public final class SearchOptionComponent: Component<EmptyDependency> {
    public func makeView(_ sortType: SortType) -> UIViewController {
        return SearchSortOptionViewController(selectedModel: sortType)
    }
}
