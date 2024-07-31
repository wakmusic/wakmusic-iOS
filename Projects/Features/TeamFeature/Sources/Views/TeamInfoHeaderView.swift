import DesignSystem
import Foundation
import TeamDomainInterface
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

    private let descriptionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.preferredMaxLayoutWidth = APP_WIDTH() - 40
    }

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

extension TeamInfoHeaderView {
    func update(entity: TeamListEntity?) {
        let target = "총괄"
        let descriptionString = "\(target) · \(entity?.name ?? "")"
        let attributedString = NSMutableAttributedString(
            string: descriptionString,
            attributes: [
                .font: UIFont.WMFontSystem.t5(weight: .medium).font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
                .kern: -0.5
            ]
        )

        attributedString.addAttributes(
            [
                .font: UIFont.WMFontSystem.t5(weight: .light).font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
                .kern: -0.5
            ],
            range: NSRange(location: 0, length: target.count)
        )
        descriptionLabel.attributedText = attributedString

        profileImageView.kf.setImage(
            with: URL(string: entity?.profile ?? ""),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
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
            $0.centerX.equalToSuperview()
            $0.height.equalTo(24)
        }
    }

    func configureUI() {
        backgroundColor = colorFromRGB(0xE4E7EC).withAlphaComponent(0.5)
    }
}
