import DesignSystem
import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import UserDomainInterface
import Utility

public protocol ListStorageTableViewCellDelegate: AnyObject {
    func buttonTapped(type: ListStorageTableViewCellDelegateConstant)
}

public enum ListStorageTableViewCellDelegateConstant {
    case playTapped((indexPath: IndexPath, key: String))
}

class ListStorageTableViewCell: UITableViewCell {
    static let reuseIdentifer = "ListStorageTableViewCell"

    private let playlistImageView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    private let nameLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
    }

    private let playButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Player.playLarge.image, for: .normal)
        $0.layer.addShadow(
            color: UIColor(hex: "#080F34"),
            alpha: 0.04,
            x: 0,
            y: 6,
            blur: 6,
            spread: 0
        )
    }

    private let lockImageView: UIImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Storage.storageClose.image
        $0.isHidden = true
    }

    private let countLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray300.color,
        font: .t7(weight: .light),
        kernValue: -0.5
    )

    private let countContainerView: UIView = UIView()

    weak var delegate: ListStorageTableViewCellDelegate?
    var passToModel: (IndexPath, String) = (IndexPath(row: 0, section: 0), "")

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addView()
        setLayout()
        setAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ListStorageTableViewCell {
    func addView() {
        self.contentView.addSubviews(
            playlistImageView,
            verticalStackView,
            playButton
        )
        verticalStackView.addArrangedSubviews(nameLabel, countContainerView)
        countContainerView.addSubviews(countLabel, lockImageView)
    }

    func setLayout() {
        playlistImageView.snp.makeConstraints {
            $0.width.height.equalTo(40)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(20)
        }

        verticalStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(playlistImageView.snp.right).offset(8)
            $0.right.equalTo(playButton.snp.left).offset(-16)
        }

        playButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(20)
        }

        nameLabel.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        countLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
        }

        lockImageView.snp.makeConstraints {
            $0.leading.equalTo(countLabel.snp.trailing)
            $0.width.height.equalTo(16)
            $0.bottom.equalToSuperview().offset(-1)
        }
    }

    func setAction() {
        self.playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    }

    func update(model: PlaylistEntity, isEditing: Bool, indexPath: IndexPath) {
        self.passToModel = (indexPath, model.key)

        self.playlistImageView.kf.setImage(
            with: URL(string: model.image),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )

        self.nameLabel.attributedText = getAttributedString(
            text: model.title,
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        )

        self.countLabel.attributedText = getAttributedString(
            text: "\(model.songCount)곡",
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12)
        )

        self.backgroundColor = model.isSelected ? DesignSystemAsset.BlueGrayColor.blueGray200.color : UIColor.clear
        self.playButton.isHidden = isEditing
        self.lockImageView.isHidden = !model.private

        self.playButton.snp.updateConstraints {
            $0.right.equalToSuperview().inset(isEditing ? -24 : 20)
        }
    }

    private func getAttributedString(
        text: String,
        font: UIFont
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
                .kern: -0.5
            ]
        )
        return attributedString
    }
}

extension ListStorageTableViewCell {
    @objc func playButtonAction() {
        delegate?.buttonTapped(type: .playTapped(passToModel))
    }
}
