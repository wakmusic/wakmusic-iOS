import DesignSystem
import Kingfisher
import LogManager
import SongsDomainInterface
import UIKit
import Utility

public protocol SongResultCellDelegate: AnyObject {
    func thumbnailDidTap(key: String)
}

final class SongResultCell: UICollectionViewCell {
    public weak var delegate: SongResultCellDelegate?

    private var model: SongEntity?

    private let thumbnailView: UIImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
    }

    private let thumnailButton: UIButton = UIButton()

    private let titleLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6(weight: .medium).lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    private let artistLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7(weight: .light).lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    private let dateLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .sc7(weight: .score3Light),
        alignment: .right,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setLayout()
        addEvent()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SongResultCell {
    private func addSubview() {
        self.contentView.addSubviews(thumbnailView, thumnailButton, titleLabel, artistLabel, dateLabel)
    }

    private func setLayout() {
        thumbnailView.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
            $0.top.bottom.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(20)
        }

        thumnailButton.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
            $0.horizontalEdges.equalTo(thumbnailView.snp.horizontalEdges)
            $0.leading.equalTo(thumbnailView.snp.leading)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(thumbnailView.snp.top)
            $0.leading.equalTo(thumbnailView.snp.trailing).offset(8)
        }

        artistLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.trailing.equalTo(titleLabel.snp.trailing)
            $0.bottom.equalTo(thumbnailView.snp.bottom)
        }

        dateLabel.snp.makeConstraints {
            $0.width.lessThanOrEqualTo(66)
            $0.centerY.equalTo(thumbnailView.snp.centerY)
            $0.trailing.equalToSuperview().inset(20)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
    }

    public func addEvent() {
        thumnailButton.addAction { [weak self] in

            guard let model = self?.model else {
                return
            }

            self?.delegate?.thumbnailDidTap(key: model.id)
        }
    }

    public func update(_ model: SongEntity) {
        self.model = model
        thumbnailView.kf.setImage(
            with: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toURL,
            placeholder: DesignSystemAsset.Logo.placeHolderMedium.image,
            options: [.transition(.fade(0.2))]
        )
        titleLabel.text = model.title
        artistLabel.text = model.artist
        dateLabel.text = model.date
        self.contentView.backgroundColor = model.isSelected ? DesignSystemAsset.BlueGrayColor.gray200.color : .clear
    }
}
