import DesignSystem
import Foundation
import TeamDomainInterface
import UIKit
import Utility

final class TeamInfoListCell: UITableViewCell {
    private let outsideStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 0
    }

    private let topSpacingView = UIView()
    private let outsideView = UIView()
    private let bottomSpacingView = UIView()

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

    private let descriptionStackView = UIStackView().then {
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
    static func cellHeight(index: Int, totalCount: Int) -> CGFloat {
        if totalCount == 1 {
            return 12 + 40 + 12

        } else {
            if index == 0 {
                return 8 + 4 + 40 + 4

            } else if index == totalCount - 1 {
                return 4 + 40 + 4 + 8

            } else {
                return 4 + 40 + 4
            }
        }
    }

    func update(entity: TeamListEntity, index: Int, totalCount: Int) {
        leadLabel.isHidden = !entity.isLead
        nameLabel.text = entity.name
        positionLabel.text = entity.position

        if totalCount == 1 {
            topSpacingView.isHidden = false
            bottomSpacingView.isHidden = false

        } else {
            if index == 0 {
                topSpacingView.isHidden = false
                bottomSpacingView.isHidden = true

            } else if index == totalCount - 1 {
                topSpacingView.isHidden = true
                bottomSpacingView.isHidden = false

            } else {
                topSpacingView.isHidden = true
                bottomSpacingView.isHidden = true
            }
        }

        profileImageView.kf.setImage(
            with: URL(string: entity.profile),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}

private extension TeamInfoListCell {
    func addSubViews() {
        contentView.addSubviews(outsideStackView)
        outsideStackView.addArrangedSubviews(topSpacingView, outsideView, bottomSpacingView)
        outsideView.addSubviews(leadLabel, profileImageView, descriptionStackView)
        descriptionStackView.addArrangedSubviews(nameLabel, positionLabel)
    }

    func setLayout() {
        outsideStackView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.centerY.equalToSuperview()
        }

        topSpacingView.snp.makeConstraints {
            $0.height.equalTo(8)
        }

        outsideView.snp.makeConstraints {
            $0.height.equalTo(4 + 40 + 4)
        }

        bottomSpacingView.snp.makeConstraints {
            $0.height.equalTo(8)
        }

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

        descriptionStackView.snp.makeConstraints {
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
        backgroundColor = UIColor.clear
        contentView.backgroundColor = colorFromRGB(0xE4E7EC).withAlphaComponent(0.5)
    }
}
