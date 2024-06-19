import UIKit
import NeedleFoundation
import SearchDomainInterface

public final class SearchSortOptionComponent: Component<EmptyDependency> {
    public func makeView(_ selectedModel: SortType) -> UIViewController {
        return SearchSortOptionViewController(selectedModel: selectedModel)
    }
}
