import SnapKit
import Then
import UIKit

public final class WMNavigationBarView: UIView {
    private let leftStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .leading
    }

    public private(set) var titleView = UIView()
    private let rightStackView = UIStackView().then {
        $0.isUserInteractionEnabled = true
        $0.axis = .horizontal
        $0.alignment = .trailing
        $0.distribution = .fillEqually
    }

    private let horizontalInset: CGFloat

    public init(horizontalInset: CGFloat = 20) {
        self.horizontalInset = horizontalInset
        super.init(frame: .zero)
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setTitle(_ text: String) {
        let titleLabel = UILabel()
        titleLabel.font = .setFont(.t5(weight: .medium))
        self.titleView = titleLabel
    }

    public func setTitleView(_ view: UIView) {
        self.titleView = view
    }

    public func setRightViews(_ views: [UIView]) {
        rightStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            rightStackView.removeArrangedSubview($0)
        }
        views.forEach(rightStackView.addArrangedSubview(_:))
    }

    public func setLeftViews(_ views: [UIView]) {
        leftStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            leftStackView.removeArrangedSubview($0)
        }
        views.forEach(leftStackView.addArrangedSubview(_:))
    }
}

private extension WMNavigationBarView {
    func addView() {
        self.addSubview(leftStackView)
        self.addSubview(titleView)
        self.addSubview(rightStackView)
    }

    func setLayout() {
        leftStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(horizontalInset)
            $0.centerY.equalToSuperview()
        }
        titleView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        rightStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(horizontalInset)
            $0.centerY.equalToSuperview()
        }
    }
}
