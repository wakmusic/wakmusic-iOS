import UIKit

public protocol FruitDrawViewControllerDelegate: AnyObject {
    func completedFruitDraw(itemCount: Int)
}

public protocol FruitDrawFactory {
    func makeView(delegate: FruitDrawViewControllerDelegate) -> UIViewController
}
