import BaseFeatureInterface
import MyInfoFeatureInterface
import NeedleFoundation
import UIKit

public protocol TeamInfoDependency: Dependency {}

public final class TeamInfoComponent: Component<TeamInfoDependency> {
    public func makeView() -> UIViewController {
        return TeamInfoViewController.viewController(
            reactor: TeamInfoReactor()
        )
    }
}
