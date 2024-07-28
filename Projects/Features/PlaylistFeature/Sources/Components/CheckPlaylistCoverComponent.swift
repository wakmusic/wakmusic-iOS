import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public protocol CheckPlaylistCoverDependency: Dependency {
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class CheckPlaylistCoverComponent: Component<CheckPlaylistCoverDependency>, CheckPlaylistCoverFactory {
    public func makeView(delegate: any CheckPlaylistCoverDelegate, imageData: Data) -> UIViewController {
        let reactor = CheckPlaylistCoverlReactor(imageData: imageData)

        return CheckPlaylistCoverViewController(
            reactor: reactor,
            textPopUpFactory: dependency.textPopUpFactory,
            delegate: delegate
        )
    }
}
