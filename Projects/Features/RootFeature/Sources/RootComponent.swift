import UIKit
import MainTabFeature
import NeedleFoundation
import DomainModule

public protocol RootDependency: Dependency {
    var mainContainerComponent: MainContainerComponent { get }
    var fetchUserInfoUseCase: any FetchUserInfoUseCase {get}
}

public final class RootComponent: Component<RootDependency> {
    public func makeView() -> IntroViewController {
        return IntroViewController.viewController(
                component: self.dependency.mainContainerComponent,
                viewModel: IntroViewModel(fetchUserInfoUseCase: dependency.fetchUserInfoUseCase)
        )
    }
}
