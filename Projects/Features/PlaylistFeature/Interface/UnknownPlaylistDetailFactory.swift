import BaseFeatureInterface
import UIKit

@MainActor
public protocol UnknownPlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
}
