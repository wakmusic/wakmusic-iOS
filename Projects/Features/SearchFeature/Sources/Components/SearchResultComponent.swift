import BaseFeature
import UIKit
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface

public final class SearchResultComponent: Component<EmptyDependency>, SearchResultFactory {
    public func makeIntegratedView(type: TabPosition, dataSource: [Int]) -> UIViewController {
        IntegratedSearchResultViewController(reactor: IntegratedSearchResultReactor())
    }
    
    public func makeSingleView(type: SearchFeatureInterface.TabPosition, dataSource: [Int]) -> UIViewController {
        UIViewController()
    }
    
    
 
}

