import BaseFeatureInterface
import UIKit

public enum PlaylistDetailKind: Sendable {
    case wakmu
    case my
    case unknown
}

@MainActor
public protocol PlaylistDetailFactory {
    func makeView(key: String) -> UIViewController
    func makeWmView(key: String) -> UIViewController
}
