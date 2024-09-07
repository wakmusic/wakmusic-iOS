import PlaylistFeatureInterface
import UIKit

public final class PlaylistDetailFactoryStub: PlaylistDetailFactory {
    public func makeView(key: String) -> UIViewController {
        return UIViewController()
    }

    public func makeWmView(key: String) -> UIViewController {
        return UIViewController()
    }
}
