import BaseFeature
import DesignSystem
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import UserDomainInterface
import Utility

public protocol LikeStorageTableViewCellDelegate: AnyObject {
    func buttonTapped(type: LikeStorageTableViewCellDelegateConstant)
}

public enum LikeStorageTableViewCellDelegateConstant {
    case playTapped(song: FavoriteSongEntity)
}

class LikeStorageTableViewCell: UITableViewCell {
    static let reuseIdentifer = "LikeStorageTableViewCell"

    private let albumImageView = UIImageView().then {
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
        $0.isUserInteractionEnabled = true
    }

    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 2
    }

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t6(weight: .medium),
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private let artistLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.BlueGrayColor.blueGray900.color,
        font: .t7(weight: .light),
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
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

    weak var delegate: LikeStorageTableViewCellDelegate?
    var indexPath: IndexPath?
    var model: FavoriteSongEntity?

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

extension LikeStorageTableViewCell {
    func update(model: FavoriteSongEntity, isEditing: Bool, indexPath: IndexPath) {
        self.indexPath = indexPath
        self.model = model

        self.albumImageView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.songID).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        self.titleLabel.text = model.title
        self.artistLabel.text = model.artist

        self.backgroundColor = model.isSelected ? DesignSystemAsset.BlueGrayColor.blueGray200.color : UIColor.clear
        self.playButton.isHidden = isEditing

        self.playButton.snp.updateConstraints {
            $0.right.equalToSuperview().inset(isEditing ? -24 : 20)
        }
    }
}

private extension LikeStorageTableViewCell {
    func addView() {
        self.contentView.addSubviews(
            albumImageView,
            verticalStackView,
            playButton
        )
        verticalStackView.addArrangedSubviews(titleLabel, artistLabel)
    }

    func setLayout() {
        albumImageView.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
            $0.left.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        verticalStackView.snp.makeConstraints {
            $0.left.equalTo(albumImageView.snp.right).offset(8)
            $0.right.equalTo(playButton.snp.left).offset(-16)
            $0.centerY.equalToSuperview()
        }

        playButton.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.right.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.height.equalTo(22)
        }

        artistLabel.snp.makeConstraints {
            $0.height.equalTo(18)
        }
    }

    func setAction() {
        self.playButton.addTarget(self, action: #selector(playButtonAction), for: .touchUpInside)
    }
}

private extension LikeStorageTableViewCell {
    @objc func playButtonAction() {
        guard let model else { return }
        delegate?.buttonTapped(type: .playTapped(song: model))
    }
}
