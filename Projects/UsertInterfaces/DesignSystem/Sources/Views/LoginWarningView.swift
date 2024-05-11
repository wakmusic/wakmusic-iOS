import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import Utility

public final class LoginWarningView: UIView {
    private let disposeBag = DisposeBag()

    private let completion: () -> Void

    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Search.warning.image
    }

    private let label: UILabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        $0.numberOfLines = .zero
    }

    private let button: UIButton = UIButton().then {
        $0.titleLabel?.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray600.color, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray400.color.cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }

    public init(
        frame: CGRect = CGRect(x: .zero, y: .zero, width: 164, height: 176),
        text: String = "로그인을 해주세요.",
        _ completion: @escaping (() -> Void)
    ) {
        self.completion = completion
        super.init(frame: frame)

        self.addSubview(imageView)
        self.addSubview(label)
        self.addSubview(button)

        label.text = text

        configureUI()

        button.rx
            .tap
            .withUnretained(self)
            .bind { owner, _ in
                owner.completion()
            }
            .disposed(by: disposeBag)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LoginWarningView {
    private func configureUI() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(56)
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16)
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
