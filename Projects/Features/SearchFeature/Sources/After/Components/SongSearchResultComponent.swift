import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import SearchDomainInterface
import SearchFeatureInterface
import SignInFeatureInterface
import UIKit

public protocol SongSearchResultDependency: Dependency {
    var fetchSearchSongsUseCase: any FetchSearchSongsUseCase { get }
    var searchSortOptionComponent: SearchSortOptionComponent { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var searchGlobalScrollState: any SearchGlobalScrollProtocol { get }
    var songDetailPresenter: any SongDetailPresentable { get }
    var signInFactory: any SignInFactory { get }
    var textPopupFactory: any TextPopupFactory { get }
}

public final class SongSearchResultComponent: Component<SongSearchResultDependency>, SongSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        SongSearchResultViewController(
            SongSearchResultReactor(
                text: text,
                fetchSearchSongsUseCase: dependency.fetchSearchSongsUseCase
            ),
            searchSortOptionComponent: dependency.searchSortOptionComponent,
            songDetailPresenter: dependency.songDetailPresenter,
            containSongsFactory: dependency.containSongsFactory,
            signInFactory: dependency.signInFactory,
            textPopupFactory: dependency.textPopupFactory,
            searchGlobalScrollState: dependency.searchGlobalScrollState
        )
    }
}
