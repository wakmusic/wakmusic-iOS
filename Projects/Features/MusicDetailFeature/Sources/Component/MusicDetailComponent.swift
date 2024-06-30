import MusicDetailFeatureInterface
import NeedleFoundation
import UIKit

protocol MusicDetailDependency {}

final class MusicDetailComponent: Component<MusicDetailDependency>, MusicDetailFactory {
    func makeViewController() -> UIViewController {
        fatalError("")
        #warning("구현")
    }
}
