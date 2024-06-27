import BaseFeatureInterface
import UIKit

public protocol MyPlaylistFactory {
    func makeView(key: String) -> UIViewController
}
