import UIKit

@MainActor
public protocol FruitDrawViewControllerDelegate: AnyObject {
    func completedFruitDraw(itemCount: Int)
}

@MainActor
public protocol FruitDrawFactory {
    func makeView(delegate: FruitDrawViewControllerDelegate) -> UIViewController
}
