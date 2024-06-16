import UIKit

extension UICollectionView {
    
    public func setBackgroundView(_ view: UIView) {
        self.backgroundView = view
    }
    
    public func restore() {
        self.backgroundView = nil
    }
    
}
