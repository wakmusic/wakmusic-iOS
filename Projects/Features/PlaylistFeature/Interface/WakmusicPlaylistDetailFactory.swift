import BaseFeatureInterface
import UIKit

@MainActor
public protocol WakmusicPlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
}
