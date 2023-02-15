import Foundation
import StorageFeature
import SearchFeature
import ArtistFeature
import NeedleFoundation

public protocol MainTabBarDependency: Dependency {
    var searchComponent: SearchComponent { get }
    var artistComponent: ArtistComponent { get }
    var storageComponent: StorageComponent { get }
}

public final class MainTabBarComponent: Component<MainTabBarDependency> {
    public func makeView() -> MainTabBarViewController {
        return MainTabBarViewController.viewController(
            searchComponent: self.dependency.searchComponent,
            artistComponent: self.dependency.artistComponent,
            storageCompoent: self.dependency.storageComponent
        )
    }
}
