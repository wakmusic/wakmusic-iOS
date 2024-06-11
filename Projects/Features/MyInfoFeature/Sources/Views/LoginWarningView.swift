import DesignSystem
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

private protocol LoginWarningActionProtocol {
    var loginButtonDidTap: Observable<Void> { get }
}

final class LoginWarningView: UIView {
    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Search.warning.image
    }

    private let label = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.backgroundColor = .clear
        $0.numberOfLines = .zero
    }

    fileprivate let button: UIButton = UIButton().then {
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray600.color, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray400.color.cgColor.copy(alpha: 0.4)
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }

    init(text: String = "로그인을 해주세요.") {
        super.init(frame: .zero)
        label.text = text
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginWarningView {
    func addView() {
        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(button)
    }

    func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(80)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.centerX.equalTo(imageView.snp.centerX)
        }

        button.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.width.equalTo(164)
            $0.top.equalTo(label.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
    }
}

extension Reactive: LoginWarningActionProtocol where Base: LoginWarningView {
    var loginButtonDidTap: Observable<Void> { base.button.rx.tap.asObservable() }
}
