import DesignSystem
import Foundation
import UIKit
import Utility

final class TeamInfoHeaderView: UIView {
    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 28
        $0.clipsToBounds = true
    }

    private let crownImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = DesignSystemAsset.Team.crown.image
    }

    private let descriptionLabel = WMLabel(
        text: "총괄",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t5(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t5(weight: .medium).lineHeight
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TeamInfoHeaderView {
    func addSubViews() {
        addSubviews(profileImageView, crownImageView, descriptionLabel)
    }

    func setLayout() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(33)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(56)
        }

        crownImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(24)
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
    }

    func configureUI() {
        backgroundColor = colorFromRGB(0xE4E7EC, alpha: 0.5)
        profileImageView.backgroundColor = UIColor.random()
    }
}
