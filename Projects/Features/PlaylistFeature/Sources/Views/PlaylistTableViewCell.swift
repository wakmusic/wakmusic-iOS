import DesignSystem
import Kingfisher
import Lottie
import RxGesture
import RxSwift
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

@MainActor
internal protocol PlaylistTableViewCellDelegate: AnyObject {
    func playButtonDidTap(model: PlaylistItemModel)
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
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    lazy var artistLabel = WMLabel(
        text: "아티스트명",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
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

    internal lazy var superButton = UIButton()
    internal weak var delegate: PlaylistTableViewCellDelegate?

    internal var model: (index: Int, model: PlaylistItemModel?) = (0, nil)

    internal var isAnimating: Bool = false
    private let disposeBag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureContents()
        bindAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }

    private func configureContents() {
        self.backgroundColor = .clear
        self.contentView.addSubview(self.thumbnailImageView)
        self.contentView.addSubview(self.titleArtistStackView)
        self.contentView.addSubview(self.playImageView)
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
    }
}

extension PlaylistTableViewCell {
    internal func setContent(
        model: PlaylistItemModel,
        index: Int,
        isEditing: Bool,
        isSelected: Bool
    ) {
        self.thumbnailImageView.kf.setImage(
            with: URL(string: Utility.WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )

        self.titleLabel.text = model.title
        self.artistLabel.text = model.artist
        self.model = (index, model)
        self.backgroundColor = isSelected ? DesignSystemAsset.BlueGrayColor.gray200.color : UIColor.clear

        self.updateButtonHidden(isEditing: isEditing)
        self.updateConstraintPlayImageView(isEditing: isEditing)
    }

    func bindAction() {
        playImageView.rx.tapGesture()
            .when(.recognized)
            .bind(with: self) { owner, _ in
                guard let song = owner.model.model else {
                    return
                }

                owner.delegate?.playButtonDidTap(model: song)
            }
            .disposed(by: disposeBag)
    }

    private func updateButtonHidden(isEditing: Bool) {
        if isEditing {
            playImageView.isHidden = true
        } else {
            playImageView.isHidden = false
        }
    }

    private func updateConstraintPlayImageView(isEditing: Bool) {
        let offset = isEditing ? 22 : -20
        self.playImageView.snp.updateConstraints {
            $0.right.equalToSuperview().offset(offset)
        }
    }
}
