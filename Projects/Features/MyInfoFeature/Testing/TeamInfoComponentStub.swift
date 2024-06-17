import BaseFeatureInterface
import MyInfoFeatureInterface
@testable import MyInfoFeature
import UIKit

public final class TeamInfoComponentStub: TeamInfoFactory {
    public func makeView() -> UIViewController {
        return TeamInfoViewController.viewController(
            reactor: TeamInfoReactor()
        )
    }
}
