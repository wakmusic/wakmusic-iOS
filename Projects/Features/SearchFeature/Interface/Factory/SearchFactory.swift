import BaseFeatureInterface
import UIKit

@MainActor
public protocol SearchFactory {
    func makeView() -> UIViewController
}
