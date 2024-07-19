import DesignSystem
import Foundation
import TeamDomainInterface
import UIKit
import Utility

final class TeamInfoListCell: UITableViewCell {
    private let leadLabel = WMLabel(
        text: "팀장",
        textColor: .white,
        font: .t8(weight: .medium),
        alignment: .center
    ).then {
        $0.backgroundColor = DesignSystemAsset.PrimaryColorV2.sub1.color
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    private let profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }

    private let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }

    private let nameLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium)
    )

    private let positionLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t7(weight: .light)
    )

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubViews()
        setLayout()
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TeamInfoListCell {
    func update(entity: TeamListEntity) {
        leadLabel.isHidden = !entity.isLead
        nameLabel.text = entity.name
        positionLabel.text = entity.position
    }
}

private extension TeamInfoListCell {
    func addSubViews() {
        contentView.addSubviews(leadLabel, profileImageView, stackView)
        stackView.addArrangedSubviews(nameLabel, positionLabel)
    }

    func setLayout() {
        leadLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(39)
            $0.height.equalTo(24)
        }

        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(leadLabel.snp.trailing).offset(9)
            $0.centerY.equalTo(leadLabel.snp.centerY)
            $0.size.equalTo(32)
        }

        stackView.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(leadLabel.snp.centerY)
            $0.trailing.equalToSuperview().offset(-20)
        }

        nameLabel.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        positionLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
    }

    func configureUI() {
        contentView.backgroundColor = colorFromRGB(0xEBEDF1)
        profileImageView.backgroundColor = UIColor.random()
    }
}
