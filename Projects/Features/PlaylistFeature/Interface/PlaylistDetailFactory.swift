import BaseFeatureInterface
import UIKit

public enum PlaylistDetailKind {
    case wakmu
    case my
    case unknown
}

public protocol PlaylistDetailFactory {
    func makeView(key: String, ownerId: String) -> UIViewController
    func makeView(key: String) -> UIViewController
}
