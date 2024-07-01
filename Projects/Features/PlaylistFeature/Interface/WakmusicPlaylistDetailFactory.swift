import BaseFeatureInterface
import UIKit

public protocol WakmusicPlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
}
