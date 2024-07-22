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
    var playlistDetailFactory: any PlaylistDetailFactory { get }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol { get }
}

public final class ListSearchResultComponent: Component<ListSearchResultDependency>, ListSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        ListSearchResultViewController(
            ListSearchResultReactor(
                text: text,
                fetchSearchPlaylistsUseCase: dependency.fetchSearchPlaylistsUseCase
            ),
            searchSortOptionComponent: dependency.searchSortOptionComponent,
            playlistDetailFactory: dependency.playlistDetailFactory,
            searchGlobalScrollState: dependency.searchGlobalScrollState
        )
    }
}
