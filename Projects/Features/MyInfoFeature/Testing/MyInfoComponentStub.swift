import BaseFeatureInterface
@testable import BaseFeatureTesting
@testable import MyInfoFeature
import MyInfoFeatureInterface
import SignInFeatureInterface
@testable import SignInFeatureTesting
import UIKit

public final class MyInfoComponentStub: MyInfoFactory, @unchecked Sendable {
    public func makeView() -> UIViewController {
        return UIViewController()
    }
}
