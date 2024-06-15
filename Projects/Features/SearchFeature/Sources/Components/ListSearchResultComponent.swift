import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import UIKit
import SearchDomainInterface

public protocol ListSearchResultDependency: Dependency {
    
    var fetchSearcPlaylistsUseCase: any FetchSearchPlaylistsUseCase { get }
    
}

public final class ListSearchResultComponent: Component<ListSearchResultDependency>, ListSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        ListSearchResultViewController(reactor: ListSearchResultReactor(
            text: text,
            fetchSearcPlaylistsUseCase: dependency.fetchSearcPlaylistsUseCase)
        
        )
    }
}
