import BaseFeatureInterface
import UIKit

public protocol MyPlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
}
