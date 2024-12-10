import SnapKit
import Then
import UIKit

@MainActor
public final class WMNavigationBarView: UIView {
    private let leftStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
    }

    public private(set) var titleView: UIView = UIView()
    private let rightStackView = UIStackView().then {
        $0.isUserInteractionEnabled = true
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .fillEqually
        $0.spacing = 10
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

    public func setTitle(
        _ text: String,
        textColor: UIColor = DesignSystemAsset.NewGrayColor.gray900.color
    ) {
        let titleLabel = WMLabel(
            text: text,
            textColor: textColor,
            font: .t5(weight: .medium),
            alignment: .center
        )
        titleView.removeFromSuperview()
        self.titleView = titleLabel

        self.addSubview(titleView)
        titleView.snp.remakeConstraints {
            $0.center.equalToSuperview()
        }
    }

    public func setTitleView(_ view: UIView) {
        titleView.removeFromSuperview()
        self.titleView = view

        self.addSubview(titleView)
        titleView.snp.remakeConstraints {
            $0.center.equalToSuperview()
        }
    }

    public func setRightViews(_ views: [UIView]) {
        rightStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            rightStackView.removeArrangedSubview($0)
        }
        views.forEach { rightStackView.addArrangedSubview($0) }
    }

    public func setLeftViews(_ views: [UIView]) {
        leftStackView.arrangedSubviews.forEach {
            $0.removeFromSuperview()
            leftStackView.removeArrangedSubview($0)
        }
        views.forEach { leftStackView.addArrangedSubview($0) }
    }
}

private extension WMNavigationBarView {
    func addView() {
        self.addSubview(leftStackView)
        self.addSubview(rightStackView)
    }

    func setLayout() {
        leftStackView.snp.makeConstraints {
            $0.left.equalToSuperview().inset(horizontalInset)
            $0.centerY.equalToSuperview()
        }
        rightStackView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(horizontalInset)
            $0.centerY.equalToSuperview()
        }
    }
}
