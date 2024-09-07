import AuthDomainInterface
import BaseFeatureInterface
import Foundation
import NeedleFoundation
import PlaylistDomainInterface
import UIKit
import UserDomainInterface

public final class MultiPurposePopupComponent: Component<EmptyDependency>, MultiPurposePopupFactory {
    public func makeView(
        type: PurposeType,
        key: String,
        completion: ((String) -> Void)?
    ) -> UIViewController {
        return MultiPurposePopupViewController.viewController(
            viewModel: .init(
                type: type,
                key: key
            ),
            completion: completion
        )
    }
}
