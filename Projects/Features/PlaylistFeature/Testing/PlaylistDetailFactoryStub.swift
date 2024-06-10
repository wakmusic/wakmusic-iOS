import PlaylistFeatureInterface
import UIKit

public final class PlaylistDetailFactoryStub: PlaylistDetailFactory {
    #warning("뷰컨은 어떻게 만들어낼 지 ??")
    public func makeView(id: String, isCustom: Bool) -> UIViewController {
        return UIViewController()
    }
}
