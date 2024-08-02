import BaseFeatureInterface
import CreditDomainInterface
import CreditSongListFeatureInterface
import NeedleFoundation
import UIKit
import SignInFeatureInterface

public protocol CreditSongListTabItemDependency: Dependency {
    var fetchCreditSongListUseCase: any FetchCreditSongListUseCase { get }
    var containSongsFactory: any ContainSongsFactory { get }
    var textPopUpFactory: any TextPopUpFactory { get }
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
            textPopupFactory: dependency.textPopUpFactory,
            signInFactory: dependency.signInFactory
        )
        return viewController
    }
}
