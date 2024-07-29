import CreditSongListFeatureInterface
import NeedleFoundation
import UIKit

public protocol CreditSongListDependency: Dependency {
    var creditSongListTabFactory: any CreditSongListTabFactory { get }
}

public final class CreditSongListComponent: Component<CreditSongListDependency>, CreditSongListFactory {
    public func makeViewController(workerName: String) -> UIViewController {
        let reactor = CreditSongListReactor(workerName: workerName)
        let viewController = CreditSongListViewController(
            reactor: reactor,
            creditSongListTabFactory: dependency.creditSongListTabFactory
        )
        return viewController
    }
}
