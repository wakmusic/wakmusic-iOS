import RxSwift
import SnapKit
import Then
import UIKit

public protocol WMRetryWarningViewDelegate: AnyObject {
    func tappedRetryButton()
}

public final class WMRetryWarningView: UIView {
    private let warningImageView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = DesignSystemAsset.Search.warning.image
    }

    private let descriptionLabel: WMLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .light),
        alignment: .center,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 0
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let screenWidth = windowScene?.screen.bounds.size.width ?? .zero
        $0.preferredMaxLayoutWidth = screenWidth - 40
    }

    private let retryButton: UIButton = UIButton(
        type: .system
    ).then {
        $0.titleLabel?.font = UIFont.WMFontSystem.t6(weight: .medium).font
        $0.titleLabel?.setTextWithAttributes(
            lineHeight: UIFont.WMFontSystem.t6(weight: .medium).font.lineHeight,
            alignment: .center
        )
        $0.setTitleColor(DesignSystemAsset.BlueGrayColor.blueGray600.color, for: .normal)
        $0.layer.cornerRadius = 8
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray400.color.withAlphaComponent(0.4).cgColor
        $0.layer.borderWidth = 1
        $0.clipsToBounds = true
    }

    public weak var delegate: WMRetryWarningViewDelegate?

    public init(
        description: String,
        retryButtonTitle: String
    ) {
        super.init(frame: .zero)
        addSubviews()
        setLayout()
        configureUI(
            description: description,
            retryButtonTitle: retryButtonTitle
        )
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WMRetryWarningView {
    func addSubviews() {
        addSubview(warningImageView)
        addSubview(descriptionLabel)
        addSubview(retryButton)
    }

    func setLayout() {
        warningImageView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.size.equalTo(80)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(warningImageView.snp.bottom).offset(-2)
            $0.horizontalEdges.greaterThanOrEqualTo(0)
            $0.centerX.equalTo(warningImageView.snp.centerX)
        }

        retryButton.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(44)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            $0.centerX.bottom.equalToSuperview()
        }
    }

    func configureUI(
        description: String,
        retryButtonTitle: String
    ) {
        descriptionLabel.text = description
        retryButton.setTitle(retryButtonTitle, for: .normal)
        retryButton.addTarget(self, action: #selector(retryButtonAction), for: .touchUpInside)
    }

    @objc func retryButtonAction() {
        delegate?.tappedRetryButton()
    }
}
