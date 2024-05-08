import NeedleFoundation
import UIKit
import MyInfoFeatureInterface

public protocol MyInfoDependency: Dependency {}

public final class MyInfoComponent: Component<MyInfoDependency>, MyInfoFactory {
    public func makeView() -> UIViewController {
        return MyInfoViewController()
    }
}
