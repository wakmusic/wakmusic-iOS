import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol OptionButtonActionProtocol {
    var didTap: Observable<Void> { get }
}

final class OptionButton: UIView {
    private let leftLabel = UILabel().then {
        $0.font = .setFont(.t6(weight: .medium))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
    }

    private let rightImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Search.arrowDown.image
    }

    public init() {
        super.init(frame: .zero)
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setLeftTitle(_ title: String) {
        leftLabel.text = title
    }
}

extension OptionButton {
    private func addView() {
        self.addSubviews(
            leftLabel,
            rightImageView
        )
    }

    private func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(22)
        }
        leftLabel.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.leading.equalTo(leftLabel.snp.trailing).offset(3)
            $0.trailing.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
    }
}

extension Reactive: OptionButtonActionProtocol where Base: OptionButton {
    var didTap: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        base.addGestureRecognizer(tapGestureRecognizer)
        base.isUserInteractionEnabled = true
        return tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }
}