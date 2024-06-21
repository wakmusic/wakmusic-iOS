import DesignSystem
import Kingfisher
import Lottie
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

internal protocol PlaylistTableViewCellDelegate: AnyObject {
    func superButtonTapped(index: Int)
}

internal class PlaylistTableViewCell: UITableViewCell {
    static let identifier = "PlaylistTableViewCell"

    internal lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailSmall.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    internal lazy var titleArtistStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel]).then {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    lazy var titleLabel = WMLabel(
        text: "곡 제목",
        textColor: DesignSystemAsset.GrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    lazy var artistLabel = WMLabel(
        text: "아티스트명",
        textColor: DesignSystemAsset.GrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    internal lazy var playImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.playLarge.image
        $0.layer.shadowColor = UIColor(red: 0.03, green: 0.06, blue: 0.2, alpha: 0.04).cgColor
        $0.layer.shadowOpacity = 1.0
        $0.layer.shadowOffset = CGSize(width: 0, height: 5.33)
        $0.layer.shadowRadius = 5.33
    }

    internal lazy var waveStreamAnimationView =
        LottieAnimationView(name: "WaveStream", bundle: DesignSystemResources.bundle).then {
            $0.loopMode = .loop
            $0.contentMode = .scaleAspectFit
        }

    internal lazy var superButton = UIButton().then {
        $0.addTarget(self, action: #selector(superButtonSelectedAction), for: .touchUpInside)
    }

    internal weak var delegate: PlaylistTableViewCellDelegate?

    internal var model: (index: Int, song: SongEntity?) = (0, nil)

    internal var isPlaying: Bool = false

    internal var isAnimating: Bool = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        isPlaying = false
    }

    private func configureContents() {
        self.backgroundColor = .clear
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.titleArtistStackView)
        self.contentView.addSubview(self.playImageView)
        self.contentView.addSubview(self.waveStreamAnimationView)
        self.contentView.addSubview(self.superButton)

        let height = 40
        let width = height * 16 / 9
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }

        titleArtistStackView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(8)
            $0.right.equalTo(playImageView.snp.left).offset(-16)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom)
        }

        playImageView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-20)
        }

        waveStreamAnimationView.snp.makeConstraints {
            $0.width.height.equalTo(32)
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.right.equalTo(contentView.snp.right).offset(-20)
        }

        superButton.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview()
            $0.right.equalToSuperview()
        }
    }
}

extension PlaylistTableViewCell {
    internal func setContent(song: SongEntity, index: Int, isEditing: Bool) {
        self.thumbnailImageView.kf.setImage(
            with: URL(string: Utility.WMImageAPI.fetchYoutubeThumbnail(id: song.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )

        self.titleLabel.text = song.title
        self.artistLabel.text = song.artist
        self.model = (index, song)
        self.backgroundColor = song.isSelected ? DesignSystemAsset.GrayColor.gray200.color : UIColor.clear

        self.updateButtonHidden(isEditing: isEditing, isPlaying: isPlaying)
        self.updateConstraintPlayImageView(isEditing: isEditing)
    }

    @objc func superButtonSelectedAction() {
        delegate?.superButtonTapped(index: model.index)
    }

    private func updateButtonHidden(isEditing: Bool, isPlaying: Bool) {
        if isEditing {
            playImageView.isHidden = true
            waveStreamAnimationView.isHidden = true
        } else {
            playImageView.isHidden = isPlaying
            waveStreamAnimationView.isHidden = !isPlaying
        }
        superButton.isHidden = !isEditing
    }

    private func updateConstraintPlayImageView(isEditing: Bool) {
        let offset = isEditing ? 22 : -20
        self.playImageView.snp.updateConstraints {
            $0.right.equalToSuperview().offset(offset)
        }
    }
}
