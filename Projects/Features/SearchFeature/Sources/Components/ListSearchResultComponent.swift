import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistFeatureInterface
import SearchDomainInterface
import SearchFeatureInterface
import UIKit

public protocol ListSearchResultDependency: Dependency {
    var fetchSearchPlaylistsUseCase: any FetchSearchPlaylistsUseCase { get }
    var searchSortOptionComponent: SearchSortOptionComponent { get }
    var unknownPlaylistDetailFactory: any UnknownPlaylistDetailFactory { get }
    var myPlaylistDetailFactory: any MyPlaylistDetailFactory { get }
}

public final class ListSearchResultComponent: Component<ListSearchResultDependency>, ListSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        ListSearchResultViewController(
            ListSearchResultReactor(
                text: text,
                fetchSearchPlaylistsUseCase: dependency.fetchSearchPlaylistsUseCase
            ),
            searchSortOptionComponent: dependency.searchSortOptionComponent,
            unknownPlaylistDetailFactory: dependency.unknownPlaylistDetailFactory,
            myPlaylistDetailFactory: dependency.myPlaylistDetailFactory
        )
    }
}
