import UIKit

@MainActor
public protocol FruitStorageFactory {
    func makeView() -> UIViewController
}
