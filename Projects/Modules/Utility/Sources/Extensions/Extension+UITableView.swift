import SnapKit
import UIKit

public extension UITableView {
    func setBackgroundView(_ view: UIView, _ topOffset: CGFloat = .zero) {
        let superView = UIView()

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
