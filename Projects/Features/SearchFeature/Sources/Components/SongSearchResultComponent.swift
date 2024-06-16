import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchDomainInterface
import SearchFeatureInterface
import UIKit

public protocol SongSearchResultDependency: Dependency {
    var fetchSearchSongsUseCase: any FetchSearchSongsUseCase { get }
}

public final class SongSearchResultComponent: Component<SongSearchResultDependency>, SongSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        SongSearchResultViewController(
            reactor: SongSearchResultReactor(
                text: text,
                fetchSearchSongsUseCase: dependency.fetchSearchSongsUseCase
            )
        )
    }
}
