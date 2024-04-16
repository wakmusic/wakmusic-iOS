import BaseFeatureInterface
import UIKit

public protocol PlaylistDetailFactory {
    func makeView(id: String, isCustom: Bool) -> UIViewController
}
