import BaseFeatureInterface
import UIKit

@MainActor
public protocol MyPlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
}
