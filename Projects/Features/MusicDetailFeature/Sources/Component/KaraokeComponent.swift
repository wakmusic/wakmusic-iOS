import MusicDetailFeatureInterface
import NeedleFoundation
import UIKit


public final class KaraokeComponent: Component<EmptyDependency>, KaraokeFactory {
    public func makeViewController(tj: Int?, ky: Int?) -> UIViewController {
        let model = PlaylistModel.SongModel.KaraokeNumber(tj: tj, ky: ky)
        
        return KaraokeViewController(model: model)
    }
    

}
