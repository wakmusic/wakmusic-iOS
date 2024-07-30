import DesignSystem
import Then
import UIKit
import Utility

final class CreditProfileView: UIStackView {
    private let creditProfileContainer = UIView().then {
        $0.backgroundColor = DesignSystemAsset.BlueGrayColor.blueGray200.color
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }

    private let creditProfileImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Logo.placeHolderLarge.image
        $0.contentMode = .scaleAspectFill
    }

    private let creditNameContainer = UIView().then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.white.color.withAlphaComponent(0.4)
        $0.layer.borderColor = DesignSystemAsset.BlueGrayColor.blueGray25.color.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 8
    }

    private let creditNameLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t1(weight: .bold)
    ).then {
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.axis = .horizontal
        self.spacing = 8
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateProfile(name: String) {
        creditNameLabel.text = name
    }
}

private extension CreditProfileView {
    func addView() {
        self.addArrangedSubviews(creditProfileContainer, creditNameContainer)
        creditProfileContainer.addSubview(creditProfileImageView)
        creditNameContainer.addSubview(creditNameLabel)
    }

    func setLayout() {
        creditProfileContainer.snp.makeConstraints {
            $0.size.equalTo(140)
        }

        creditProfileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(80)
        }

        creditNameLabel.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.top.equalToSuperview().inset(12)
            $0.bottom.lessThanOrEqualToSuperview().inset(12)
        }
    }
}
