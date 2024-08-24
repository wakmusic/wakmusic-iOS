import BaseFeatureInterface
import CreditDomainInterface
import CreditSongListFeatureInterface
import NeedleFoundation
import SignInFeatureInterface
import UIKit

public protocol CreditSongListTabItemDependency: Dependency {
    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var textPopupFactory: any TextPopupFactory { get }
    var signInFactory: any SignInFactory { get }
}

public final class CreditSongListTabItemComponent: Component<CreditSongListTabItemDependency>,
    CreditSongListTabItemFactory {
    public func makeViewController(workerName: String, sortType: CreditSongSortType) -> UIViewController {
        let reactor = CreditSongListTabItemReactor(
            workerName: workerName,
            creditSortType: sortType,
            fetchCreditSongListUseCase: dependency.fetchCreditSongListUseCase
        )
        let viewController = CreditSongListTabItemViewController(
            reactor: reactor,
            containSongsFactory: dependency.containSongsFactory,
            textPopupFactory: dependency.textPopupFactory,
            signInFactory: dependency.signInFactory
        )
        return viewController
    }
}
