import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public final class PlayTypeTogglePopupComponent: Component<EmptyDependency>, PlayTypeTogglePopupFactory {
    public func makeView(
        completion: ((_ selectedItemString: String) -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        return PlayTypeTogglePopupViewController(
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
