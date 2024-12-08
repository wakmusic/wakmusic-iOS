import PlaylistFeatureInterface
import UIKit

public final class PlaylistDetailFactoryStub: PlaylistDetailFactory, @unchecked Sendable {
    public func makeView(key: String) -> UIViewController {
        return UIViewController()
    }

    public func makeWmView(key: String) -> UIViewController {
        return UIViewController()
    }
}
