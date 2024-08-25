import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public final class TogglePopupComponent: Component<EmptyDependency>, TogglePopupFactory {
    public func makeView(
        completion: ((_ selectedItemString: String) -> Void)? = nil,
        cancelCompletion: (() -> Void)? = nil
    ) -> UIViewController {
        return TogglePopupViewController(
            completion: completion,
            cancelCompletion: cancelCompletion
        )
    }
}
