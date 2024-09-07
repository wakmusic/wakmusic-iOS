import NeedleFoundation
import SearchDomainInterface
import UIKit

public final class SearchSortOptionComponent: Component<EmptyDependency> {
    public func makeView(_ selectedModel: SortType) -> UIViewController {
        return SearchSortOptionViewController(selectedModel: selectedModel)
    }
}
