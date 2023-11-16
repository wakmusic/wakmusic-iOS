import Foundation
import NeedleFoundation
import DomainModule

public protocol NewSongsDependency: Dependency {
    var newSongsContentComponent: NewSongsContentComponent { get }
}

public final class NewSongsComponent: Component<NewSongsDependency> {
    public func makeView() -> NewSongsViewController {
        return NewSongsViewController.viewController(newSongsContentComponent: dependency.newSongsContentComponent)
    }
}
