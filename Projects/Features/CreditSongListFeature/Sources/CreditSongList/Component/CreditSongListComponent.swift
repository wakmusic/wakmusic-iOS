import CreditDomainInterface
import CreditSongListFeatureInterface
import NeedleFoundation
import UIKit

public protocol CreditSongListDependency: Dependency {
    var creditSongListTabFactory: any CreditSongListTabFactory { get }
    var fetchCreditProfileUseCase: any FetchCreditProfileUseCase { get }
}

public final class CreditSongListComponent: Component<CreditSongListDependency>, CreditSongListFactory {
    public func makeViewController(workerName: String) -> UIViewController {
        let reactor = CreditSongListReactor(
            workerName: workerName,
            fetchCreditProfileUseCase: dependency.fetchCreditProfileUseCase
        )
        let viewController = CreditSongListViewController(
            reactor: reactor,
            creditSongListTabFactory: dependency.creditSongListTabFactory
        )
        return viewController
    }
}
