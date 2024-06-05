import PlaylistFeatureInterface
import UIKit

public final class PlaylistDetailFactorySpy: PlaylistDetailFactory {
    public func makeView(id: String, isCustom: Bool) -> UIViewController {
        return UIViewController()
    }
}
