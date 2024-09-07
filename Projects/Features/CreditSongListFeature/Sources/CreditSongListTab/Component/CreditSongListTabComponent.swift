import CreditSongListFeatureInterface
import NeedleFoundation
import UIKit

public protocol CreditSongListTabDependency: Dependency {
    var creditSongListTabItemFactory: any CreditSongListTabItemFactory { get }
}

public final class CreditSongListTabComponent: Component<CreditSongListTabDependency>, CreditSongListTabFactory {
    public func makeViewController(workerName: String) -> UIViewController {
        let viewController = CreditSongListTabViewController(
            workerName: workerName,
            creditSongListTabItemFactory: dependency.creditSongListTabItemFactory
        )
        return viewController
    }
}
