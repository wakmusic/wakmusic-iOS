import PlaylistFeatureInterface
import UIKit

public final class PlaylistDetailFactoryStub: PlaylistDetailFactory {
    public func makeView(key: String, kind: PlaylistDetailKind) -> UIViewController {
        return UIViewController()
    }
}
