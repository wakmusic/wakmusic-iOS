import UIKit
import BaseFeatureInterface

public protocol PlaylistFactory {
    func makeView(id: String, isCustom: Bool) -> UIViewController
}
