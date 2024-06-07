import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import UIKit

public final class SearchResultComponent: Component<EmptyDependency>, SearchResultFactory {
    public func makeIntegratedView(type: TabPosition, dataSource: [Int]) -> UIViewController {
        SongSearchResultViewController(reactor: SongSearchResultReactor())
    }

    public func makeSingleView(type: SearchFeatureInterface.TabPosition, dataSource: [Int]) -> UIViewController {
        UIViewController()
    }
}
