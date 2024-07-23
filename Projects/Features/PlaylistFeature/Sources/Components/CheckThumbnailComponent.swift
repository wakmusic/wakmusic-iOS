import BaseFeature
import BaseFeatureInterface
import NeedleFoundation
import PlaylistFeatureInterface
import UIKit

public final class CheckThumbnailComponent: Component<EmptyDependency>, CheckThumbnailFactory {
    public func makeView(delegate: any CheckThumbnailDelegate, imageData: Data) -> UIViewController {
        
        let reactor = CheckThumbnailReactor(imageeData: imageData)
        
        return CheckThumbnailViewController(reactor: reactor ,delegate: delegate)
    }
}
