import UIKit

public protocol SignInFactory {
    func makeView() -> UIViewController
    
    func makeWarnigView(_  completion: @escaping () -> Void ) -> UIView
}
