import MusicDetailFeatureInterface
import NeedleFoundation
import UIKit

public protocol MusicDetailDependency: Dependency {}

public final class MusicDetailComponent: Component<MusicDetailDependency>, MusicDetailFactory {
    public func makeViewController() -> UIViewController {
        fatalError("")
        #warning("구현")
    }
}
