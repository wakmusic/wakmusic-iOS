import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol SettingItemActionProtocol {
    var didTap: Observable<Void> { get }
}

final class SettingItemView: UIView {
    private let leftLabel = UILabel().then {
        $0.font = .setFont(.t5(weight: .medium))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
    }

    private let rightImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Navigation.serviceInfoArrowRight.image
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

    public func setLeftTitle(_ title: String) {
        leftLabel.text = title
    }

    public func setRightImage(_ image: UIImage?) {
        rightImageView.image = image
    }
}

extension SettingItemView {
    func addView() {
        self.addSubviews(
            leftLabel,
            rightImageView
        )
    }

    func setLayout() {
        self.snp.makeConstraints {
            $0.height.equalTo(60)
        }
        leftLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(horizontalInset)
            $0.centerY.equalToSuperview()
        }
        rightImageView.snp.makeConstraints {
            $0.right.equalToSuperview().inset(horizontalInset)
            $0.centerY.equalToSuperview()
        }
    }
}

extension Reactive: SettingItemActionProtocol where Base: SettingItemView {
    var didTap: Observable<Void> {
        let tapGestureRecognizer = UITapGestureRecognizer()
        base.addGestureRecognizer(tapGestureRecognizer)
        base.isUserInteractionEnabled = true
        return tapGestureRecognizer.rx.event.map { _ in }.asObservable()
    }
}
