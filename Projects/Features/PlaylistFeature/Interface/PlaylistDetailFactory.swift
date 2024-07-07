import BaseFeatureInterface
import UIKit

public enum PlaylistDetailKind {
    case wakmu
    case my
    case unkwon
}

public protocol PlaylistDetailFactory {
    func makeView(key: String, kind: PlaylistDetailKind) -> UIViewController
}
