import UIKit

public extension UIApplication {
    static func topVisibleViewController(
        base: UIViewController? = UIApplication.keyRootViewController
    ) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topVisibleViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return topVisibleViewController(base: selected)
        }
        if let presented = base?.presentedViewController {
            return topVisibleViewController(base: presented)
        }
        return base
    }

    static var keyRootViewController: UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .filter { $0.activationState == .foregroundActive }
            .first?
            .keyWindow?
            .rootViewController
    }
}
