import BaseFeature
import BaseFeatureInterface
import Foundation
import MusicDetailFeatureInterface
import NeedleFoundation
import SearchDomainInterface
import SearchFeatureInterface
import UIKit

public protocol SongSearchResultDependency: Dependency {
    var fetchSearchSongsUseCase: any FetchSearchSongsUseCase { get }
    var searchSortOptionComponent: SearchSortOptionComponent { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol { get }
    var musicDetailFactory: any MusicDetailFactory { get }
}

public final class SongSearchResultComponent: Component<SongSearchResultDependency>, SongSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        SongSearchResultViewController(
            SongSearchResultReactor(
                text: text,
                fetchSearchSongsUseCase: dependency.fetchSearchSongsUseCase
            ),
            searchSortOptionComponent: dependency.searchSortOptionComponent,
            musicDetailFactory: dependency.musicDetailFactory,
            containSongsFactory: dependency.containSongsFactory,
            searchGlobalScrollState: dependency.searchGlobalScrollState
        )
    }
}
