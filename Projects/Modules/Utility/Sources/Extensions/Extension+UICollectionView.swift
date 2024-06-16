import UIKit
import SnapKit

extension UICollectionView {
    
    public func setBackgroundView(_ view: UIView,_ topOffset: CGFloat = .zero) {
        
        let superView = UIView(frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: APP_HEIGHT()))
        
        superView.addSubview(view)
        
        view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topOffset)
            $0.horizontalEdges.equalToSuperview()
        }
        
        
        self.backgroundView = superView
    }
    
    public func restore() {
        self.backgroundView = nil
    }
    
}
