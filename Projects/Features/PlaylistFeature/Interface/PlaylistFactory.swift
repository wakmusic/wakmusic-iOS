import BaseFeatureInterface
import UIKit

public protocol PlaylistFactory {
    func makeView(id: String, isCustom: Bool) -> UIViewController
}
