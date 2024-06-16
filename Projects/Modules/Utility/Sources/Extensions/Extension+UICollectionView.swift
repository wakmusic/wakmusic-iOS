import SnapKit
import UIKit

public extension UICollectionView {
    func setBackgroundView(_ view: UIView, _ topOffset: CGFloat = .zero) {
        let superView = UIView(frame: CGRect(x: .zero, y: .zero, width: APP_WIDTH(), height: APP_HEIGHT()))

        superView.addSubview(view)

        view.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topOffset)
            $0.horizontalEdges.equalToSuperview()
        }

        self.backgroundView = superView
    }

    func restore() {
        self.backgroundView = nil
    }
}
