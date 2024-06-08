import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import UIKit

public final class ListSearchResultComponent: Component<EmptyDependency>, ListSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        ListSearchResultViewController(reactor: ListSearchResultReactor(text))
    }
}
