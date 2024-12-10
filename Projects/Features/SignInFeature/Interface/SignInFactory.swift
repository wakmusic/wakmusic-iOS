import UIKit

@MainActor
public protocol SignInFactory {
    func makeView() -> UIViewController
}
