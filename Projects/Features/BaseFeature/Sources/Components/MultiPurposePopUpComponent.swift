import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import UIKit
import UserDomainInterface

public protocol MultiPurposePopUpDependency: Dependency {
    var createPlaylistUseCase: any CreatePlayListUseCase { get }
    var setUserNameUseCase: any SetUserNameUseCase { get }
    var updateTitleAndPrivateUseCase: any UpdateTitleAndPrivateUseCase { get }
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
                createPlaylistUseCase: dependency.createPlaylistUseCase,
                setUserNameUseCase: dependency.setUserNameUseCase,
                updateTitleAndPrivateUseCase: dependency.updateTitleAndPrivateUseCase,
                logoutUseCase: dependency.logoutUseCase
            ),
            completion: completion
        )
    }
}
