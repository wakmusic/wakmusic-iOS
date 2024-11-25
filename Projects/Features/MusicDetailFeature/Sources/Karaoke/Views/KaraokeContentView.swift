import DesignSystem
import SnapKit
import Then
import UIKit

@MainActor
private protocol KaraokeContentStateProtocol {
    func update(number: Int?, kind: KaraokeKind)
}

final class KaraokeContentView: UIView {
    private let imageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    private lazy var labelContainerView: UIView = UIView ().then {
        $0.addSubviews(titleLabel, subTitleLabel)
    }

    private let titleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray500.color,
        font: .t7(weight: .light),
        lineHeight: UIFont.WMFontSystem.t7(weight: .light).lineHeight,
        kernValue: -0.5
    )

    private let subTitleLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .medium),
        lineHeight: UIFont.WMFontSystem.t5(weight: .medium).lineHeight,
        kernValue: -0.5
    )
    init() {
        super.init(frame: .zero)
        addViews()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addViews() {
        self.addSubviews(imageView, labelContainerView)
    }

    func setLayout() {
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.leading.equalToSuperview().inset(24)
            $0.top.bottom.equalToSuperview().inset(20)
        }

        labelContainerView.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(16)
            $0.top.bottom.equalToSuperview().inset(15)
            $0.trailing.equalToSuperview().inset(44)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension KaraokeContentView: KaraokeContentStateProtocol {
    func update(number: Int?, kind: KaraokeKind) {
        imageView.image = kind.logoImage
        titleLabel.text = kind.koreanTitle

        guard let number = number else {
            subTitleLabel.text = "없음"
            return
        }

        subTitleLabel.text = "\(number)"
    }
}
