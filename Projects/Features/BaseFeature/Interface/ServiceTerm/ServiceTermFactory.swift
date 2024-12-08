import UIKit

@MainActor
public protocol ServiceTermFactory {
    func makeView() -> UIViewController
}
