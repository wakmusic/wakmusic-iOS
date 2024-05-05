import NeedleFoundation
import UIKit

public protocol MyInfoDependency: Dependency {
    
}

public final class MyInfoComponent: Component<MyInfoDependency> {
    public func makeView() -> MyInfoViewController {
            return MyInfoViewController()
    }
}

