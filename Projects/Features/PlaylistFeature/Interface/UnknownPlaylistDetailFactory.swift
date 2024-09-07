import BaseFeatureInterface
import UIKit

public protocol UnknownPlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
}
