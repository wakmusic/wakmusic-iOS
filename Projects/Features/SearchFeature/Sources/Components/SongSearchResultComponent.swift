import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import UIKit

public final class SongSearchResultComponent: Component<EmptyDependency>, SongSearchResultFactory {
    public func makeView(_ text: String) -> UIViewController {
        SongSearchResultViewController(reactor: SongSearchResultReactor(text))
    }
}
