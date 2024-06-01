import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlayListDomainInterface
import UIKit
import UserDomainInterface

public protocol MultiPurposePopUpDependency: Dependency {
    var createPlayListUseCase: any CreatePlayListUseCase { get }
    var loadPlayListUseCase: any LoadPlayListUseCase { get }
    var setUserNameUseCase: any SetUserNameUseCase { get }
    var updateTitleAndPrivateeUseCase : any UpdateTitleAndPrivateeUseCase { get }
    var logoutUseCase: any LogoutUseCase { get }
}

public final class MultiPurposePopUpComponent: Component<MultiPurposePopUpDependency>, MultiPurposePopUpFactory {
    public func makeView(
        type: PurposeType,
        key: String,
        completion: ((String) -> Void)?
    ) -> UIViewController {
        return MultiPurposePopupViewController.viewController(
            viewModel: .init(
                type: type,
                key: key,
                createPlayListUseCase: dependency.createPlayListUseCase,
                loadPlayListUseCase: dependency.loadPlayListUseCase,
                setUserNameUseCase: dependency.setUserNameUseCase,
                updateTitleAndPrivateeUseCase: dependency.updateTitleAndPrivateeUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            completion: completion
        )
    }
}
