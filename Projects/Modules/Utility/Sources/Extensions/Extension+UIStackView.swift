import UIKit

public extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach(self.addArrangedSubview(_:))
    }
}
