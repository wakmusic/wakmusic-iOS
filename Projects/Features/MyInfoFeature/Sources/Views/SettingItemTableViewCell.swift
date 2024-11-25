import DesignSystem
import MyInfoFeatureInterface
import SnapKit
import Then
import UIKit
import Utility

class SettingItemTableViewCell: UITableViewCell {
    static let reuseIdentifier = "SettingItemTableViewCell"
    var category: SettingItemCategory?

    private let titleLabel = UILabel().then {
        $0.font = .setFont(.t5(weight: .medium))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
        $0.setTextWithAttributes(kernValue: -0.5)
        $0.textAlignment = .left
        $0.numberOfLines = 2
    }

    private let subTitleLabel = UILabel().then {
        $0.font = .setFont(.t5(weight: .medium))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
        $0.setTextWithAttributes(kernValue: -0.5)
        $0.textAlignment = .right
    }

    private let rightImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Navigation.serviceInfoArrowRight.image
    }

    private let rightLabel = UILabel().then {
        $0.text = APP_VERSION()
        $0.font = .setFont(.sc7(weight: .score3Light))
        $0.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
        $0.setTextWithAttributes(kernValue: -0.5)
        $0.lineBreakMode = .byTruncatingTail
        $0.textAlignment = .right
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setLayout()
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(type: SettingItemType) {
        configureTitle(type: type)
        configureSubTitle(type: type)
        configureRightItem(type: type)
        configureIdentifier(type: type)
    }
}

private extension SettingItemTableViewCell {
    func configureTitle(type: SettingItemType) {
        switch type {
        case let .navigate(category):
            self.titleLabel.text = category.rawValue
        case let .description(category):
            self.titleLabel.text = category.rawValue
        }
    }

    func configureSubTitle(type: SettingItemType) {
        switch type {
        case let .navigate(category):
            let pushNotificationAuthorizationStatus = PreferenceManager.shared
                .pushNotificationAuthorizationStatus ?? false
            let playType = PreferenceManager.shared.songPlayPlatformType ?? .youtube
            switch category {
            case .appPush:
                self.subTitleLabel.text = pushNotificationAuthorizationStatus ? "켜짐" : "꺼짐"
            case .playType:
                self.subTitleLabel.text = playType.display
            default:
                self.subTitleLabel.text = ""
            }
        case let .description(category):
            self.subTitleLabel.text = ""
        }
    }

    func configureRightItem(type: SettingItemType) {
        switch type {
        case let .navigate(category):
            rightImageView.isHidden = false
            rightLabel.isHidden = true
            subTitleLabel.isHidden = !(category == .appPush || category == .playType)
        case .description:
            rightImageView.isHidden = true
            rightLabel.isHidden = false
            subTitleLabel.isHidden = true
        }
    }

    func configureIdentifier(type: SettingItemType) {
        switch type {
        case let .navigate(category):
            self.category = category
        case let .description(category):
            self.category = category
        }
    }
}

private extension SettingItemTableViewCell {
    func addView() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(rightImageView)
        contentView.addSubview(rightLabel)
    }

    func setLayout() {
        titleLabel.setContentCompressionResistancePriority(.init(rawValue: 749), for: .horizontal)
        titleLabel.snp.makeConstraints {
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        rightImageView.snp.makeConstraints {
            $0.width.height.equalTo(24)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(10)
            $0.right.equalTo(rightImageView.snp.left).offset(-2)
            $0.centerY.equalToSuperview()
        }

        rightLabel.snp.makeConstraints {
            $0.width.equalTo(30)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }
    }
}
