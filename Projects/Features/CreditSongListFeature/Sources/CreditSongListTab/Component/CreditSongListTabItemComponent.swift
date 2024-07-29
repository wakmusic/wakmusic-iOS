import CreditDomainInterface
import CreditSongListFeatureInterface
import NeedleFoundation
import UIKit

public protocol CreditSongListTabItemDependency: Dependency {
    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase { get }
}

public final class CreditSongListTabItemComponent: Component<CreditSongListTabItemDependency>,
    CreditSongListTabItemFactory {
    public func makeViewController(workerName: String, sortType: CreditSongSortType) -> UIViewController {
        let reactor = CreditSongListTabItemReactor(
            workerName: workerName,
            creditSortType: sortType,
            fetchCreditSongListUseCase: dependency.fetchCreditSongListUseCase
        )
        let viewController = CreditSongListTabItemViewController(reactor: reactor)
        return viewController
    }
}
