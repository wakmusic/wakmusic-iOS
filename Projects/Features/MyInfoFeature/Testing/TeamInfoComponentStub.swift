import BaseFeatureInterface
@testable import MyInfoFeature
import MyInfoFeatureInterface
import UIKit

public final class TeamInfoComponentStub: TeamInfoFactory {
    public func makeView() -> UIViewController {
        return TeamInfoViewController.viewController(
            reactor: TeamInfoReactor()
        )
    }
}
