import BaseFeatureInterface
import UIKit

public enum PlaylistDetailKind {
    case wakmu
    case my
    case unknown
}

public protocol PlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
    func makeWmView(key: String) -> UIViewController
}
