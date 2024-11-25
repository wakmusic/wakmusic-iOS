import UIKit

@MainActor
public protocol PrivacyFactory {
    func makeView() -> UIViewController
}
