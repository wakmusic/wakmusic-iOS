import BaseFeature
import UIKit
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface

public final class SearchResultComponent: Component<EmptyDependency>, SearchResultFactory {
    
    public func makeView(type: TabPosition, dataSource: [Int]) -> UIViewController {
            return SearchResultViewController(reactor: SearchResultReactor())
    }
}

