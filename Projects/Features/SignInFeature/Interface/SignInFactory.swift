import UIKit

public protocol SignInFactory {
    func makeView() -> UIViewController

    func makeWarnigView(_ frame: CGRect? ,text: String? ,_ completion: @escaping () -> Void) -> UIView
}
