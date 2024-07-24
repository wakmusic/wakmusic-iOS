import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit


public protocol CheckThumbnailDependency: Dependency {
    var textPopUpFactory: any TextPopUpFactory { get }
}

public final class CheckThumbnailComponent: Component<CheckThumbnailDependency>, CheckThumbnailFactory {
    public func makeView(delegate: any CheckThumbnailDelegate, imageData: Data) -> UIViewController {
        
        let reactor = CheckThumbnailReactor(imageeData: imageData)
        
        return CheckThumbnailViewController(reactor: reactor,
                                            textPopUpFactory: dependency.textPopUpFactory
                                            ,delegate: delegate)
    }
}
