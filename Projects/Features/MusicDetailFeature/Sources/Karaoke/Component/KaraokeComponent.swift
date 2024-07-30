import MusicDetailFeatureInterface
import NeedleFoundation
import UIKit

public final class KaraokeComponent: Component<EmptyDependency>, KaraokeFactory {
    public func makeViewController(ky: Int?, tj: Int?) -> UIViewController {
        return KaraokeViewController(ky: ky, tj: tj)
    }
}
