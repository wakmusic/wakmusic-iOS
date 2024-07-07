import BaseFeatureInterface
import UIKit

public protocol PlaylistDetailFactory {
    func makeView(key: String, isMine: Bool) -> UIViewController
}
