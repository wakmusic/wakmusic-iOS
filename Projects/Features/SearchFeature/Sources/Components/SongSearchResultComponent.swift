import BaseFeature
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import SearchFeatureInterface
import UIKit

public final class SongSearchResultComponent: Component<EmptyDependency>, SongSearchResultFactory {
    public func makeView() -> UIViewController {
        SongSearchResultViewController(reactor: SongSearchResultReactor())
    }

}
