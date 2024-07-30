import DesignSystem
import Kingfisher
import Lottie
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

internal protocol PlaylistDateTableViewCellDelegate: AnyObject {
    func thumbnailDidTap(key: String)
}

final class PlaylistDateTableViewCell: UITableViewCell {
    static let identifier = "PlaylistTableViewCell"

    private var model: SongEntity?
    weak var delegate: PlaylistDateTableViewCellDelegate?

    private lazy var thumbnailImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Player.dummyThumbnailSmall.image
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 4
        $0.clipsToBounds = true
    }

    private lazy var thumbnailButton = UIButton()

    private lazy var titleArtistStackView = UIStackView(arrangedSubviews: [titleLabel, artistLabel]).then {
        $0.axis = .vertical
        $0.distribution = .fill
    }

    private lazy var titleLabel = WMLabel(
        text: "곡 제목",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private lazy var artistLabel = WMLabel(
        text: "아티스트명",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    private lazy var dateLabel = WMLabel(
        text: "날짜",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t7(weight: .score3Light),
        alignment: .right,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.lineBreakMode = .byTruncatingTail
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
        setLayout()
        addAction()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }

    private func addViews() {
        self.contentView.addSubviews(
            self.thumbnailImageView,
            self.thumbnailButton,
            self.titleArtistStackView,
            self.dateLabel
        )
    }

    private func setLayout() {
        let height = 40
        let width = height * 16 / 9
        thumbnailImageView.snp.makeConstraints {
            $0.centerY.equalTo(contentView.snp.centerY)
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }

        thumbnailButton.snp.makeConstraints {
            $0.centerY.equalTo(thumbnailImageView)
            $0.left.equalTo(thumbnailImageView)
            $0.width.equalTo(width)
            $0.height.equalTo(height)
        }

        titleArtistStackView.snp.makeConstraints {
            $0.top.equalTo(thumbnailImageView.snp.top)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(8)
            $0.right.equalTo(dateLabel.snp.left).offset(-16)
            $0.bottom.equalTo(thumbnailImageView.snp.bottom)
        }

        dateLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(66)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
        }
    }

    private func addAction() {
        thumbnailButton.addAction { [weak self] in

            guard let model = self?.model else { return }

            self?.delegate?.thumbnailDidTap(key: model.id)
        }
    }
}

extension PlaylistDateTableViewCell {
    func update(_ model: SongEntity) {
        self.model = model

        self.thumbnailImageView.kf.setImage(
            with: URL(string: Utility.WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )

        self.titleLabel.text = model.title
        self.artistLabel.text = model.artist
        self.dateLabel.text = model.date
        self.backgroundColor = model.isSelected ? DesignSystemAsset.BlueGrayColor.gray200.color : UIColor.clear
    }
}
