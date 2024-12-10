import UIKit

@MainActor
public protocol TeamInfoFactory {
    func makeView() -> UIViewController
}
