import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchDomainInterface
import SearchFeatureInterface
import UIKit

public protocol ListSearchResultDependency: Dependency {
    var fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase { get }
    var searchSortOptionComponent: SearchSortOptionComponent { get }
}

public final class ListSearchResultComponent: Component<ListSearchResultDependency>, ListSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        ListSearchResultViewController(
            ListSearchResultReactor(
                text: text,
                fetchSearchPlaylistsUseCase: dependency.fetchSearchPlaylistsUseCase
            ),
            dependency.searchSortOptionComponent
        )
    }
}
