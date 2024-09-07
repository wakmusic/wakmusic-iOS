import BaseFeature
import ChartDomainInterface
import DesignSystem
import Kingfisher
import SnapKit
import SongsDomainInterface
import Then
import UIKit
import Utility

protocol ChartContentTableViewCellDelegate: AnyObject {
    func tappedThumbnail(id: String)
}

public final class ChartContentTableViewCell: UITableViewCell {
    // MARK: - UI
    private let rankingLabel = WMLabel(
        text: "0",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t5(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t5().lineHeight,
        kernValue: -0.5
    )

    private let nonImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.non.image
    }

    private let blowUpImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.blowup.image
    }

    private let increaseRateImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.up.image
    }

    private let decreaseRateImageView = UIImageView().then {
        $0.image = DesignSystemAsset.Chart.down.image
    }

    private let newRateLabel = WMLabel(
        text: "NEW",
        textColor: DesignSystemAsset.PrimaryColor.new.color,
        font: .t8(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t8().lineHeight,
        kernValue: -0.5
    )

    private let rateLabel = WMLabel(
        text: "0",
        textColor: DesignSystemAsset.PrimaryColor.new.color,
        font: .t8(weight: .medium),
        alignment: .center,
        lineHeight: UIFont.WMFontSystem.t8().lineHeight,
        kernValue: -0.5
    )

    private let albumImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFill
    }

    private let titleStringLabel = WMLabel(
        text: "제목",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    )

    private let groupStringLabel = WMLabel(
        text: "아티스트",
        textColor: DesignSystemAsset.BlueGrayColor.gray900.color,
        font: .t7(weight: .light),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t7().lineHeight,
        kernValue: -0.5
    )

    private let hitsLabel = UILabel().then {
        $0.textAlignment = .right
        $0.textColor = DesignSystemAsset.BlueGrayColor.gray900.color
        $0.font = DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
    }

    private let thumbnailToPlayButton = UIButton(type: .system).then {
        $0.backgroundColor = UIColor.clear
    }

    // MARK: - Property
    private var model: ChartRankingEntity?
    weak var delegate: ChartContentTableViewCellDelegate?

    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addView()
        setRankingLayout()
        setLayout()
        addTarget()
        self.selectionStyle = .none
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func prepareForReuse() {
        super.prepareForReuse()
        rateLabel.isHidden = false
        newRateLabel.isHidden = false
        nonImageView.isHidden = false
        blowUpImageView.isHidden = false
        increaseRateImageView.isHidden = false
        decreaseRateImageView.isHidden = false
    }
}

// MARK: - Layout
private extension ChartContentTableViewCell {
    func addView() {
        [
            rankingLabel,
            blowUpImageView,
            nonImageView,
            increaseRateImageView,
            decreaseRateImageView,
            newRateLabel,
            rateLabel,
            albumImageView,
            hitsLabel,
            titleStringLabel,
            groupStringLabel,
            thumbnailToPlayButton
        ].forEach {
            contentView.addSubview($0)
        }
    }

    func setRankingLayout() {
        rankingLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(20)
            $0.width.equalTo(28)
            $0.height.equalTo(24)
        }
        [increaseRateImageView, decreaseRateImageView].forEach { view in
            view.snp.makeConstraints {
                $0.top.equalTo(rankingLabel.snp.bottom).offset(2)
                $0.width.height.equalTo(12)
                $0.left.equalTo(21)
            }
        }
        rateLabel.snp.makeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom)
            $0.height.equalTo(16)
            $0.width.equalTo(14)
            $0.left.equalTo(33)
        }
        newRateLabel.snp.makeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom)
            $0.height.equalTo(16)
            $0.width.equalTo(26)
            $0.left.equalTo(21)
        }
        [blowUpImageView, nonImageView].forEach { view in
            view.snp.makeConstraints {
                $0.top.equalTo(rankingLabel.snp.bottom).offset(2)
                $0.width.height.equalTo(12)
                $0.left.equalTo(28)
            }
        }
        albumImageView.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
            $0.left.equalTo(56)
            $0.centerY.equalTo(contentView)
        }
        hitsLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.centerY.equalTo(contentView)
            $0.right.equalTo(-20)
        }
    }

    func setLayout() {
        titleStringLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(9)
            $0.left.equalTo(albumImageView.snp.right).offset(8)
            $0.right.equalTo(hitsLabel.snp.left).offset(-8)
        }
        groupStringLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.bottom.equalTo(-9)
            $0.left.equalTo(albumImageView.snp.right).offset(8)
            $0.right.equalTo(hitsLabel.snp.left).offset(-8)
        }
        thumbnailToPlayButton.snp.makeConstraints {
            $0.edges.equalTo(albumImageView)
        }
    }

    func addTarget() {
        thumbnailToPlayButton.addTarget(self, action: #selector(thumbnailToPlayButtonAction), for: .touchUpInside)
    }
}

// MARK: - Chart 등락률 화살표
private extension ChartContentTableViewCell {
    func newThenBefore() {
        newRateLabel.isHidden = false
        nonImageView.isHidden = true
        blowUpImageView.isHidden = true
        increaseRateImageView.isHidden = true
        decreaseRateImageView.isHidden = true
        rateLabel.isHidden = true
    }

    func higherThanBefore(ranking: Int) {
        rateLabel.textColor = DesignSystemAsset.PrimaryColor.increase.color
        rateLabel.text = "\(ranking)"
        rateLabel.isHidden = false
        newRateLabel.isHidden = true
        nonImageView.isHidden = true
        blowUpImageView.isHidden = true
        increaseRateImageView.isHidden = false
        decreaseRateImageView.isHidden = true
    }

    func lowerThanBefore(ranking: Int) {
        let minusBeforeRanking = "\(ranking)"
        rateLabel.textColor = DesignSystemAsset.PrimaryColor.decrease.color
        rateLabel.text = minusBeforeRanking.trimmingCharacters(in: ["-"])
        rateLabel.isHidden = false
        newRateLabel.isHidden = true
        nonImageView.isHidden = true
        blowUpImageView.isHidden = true
        increaseRateImageView.isHidden = true
        decreaseRateImageView.isHidden = false
    }

    func sameAsBefore() {
        rateLabel.isHidden = true
        newRateLabel.isHidden = true
        nonImageView.isHidden = false
        blowUpImageView.isHidden = true
        rateLabel.isHidden = true
        increaseRateImageView.isHidden = true
        decreaseRateImageView.isHidden = true
    }

    func blowThenBefore() {
        rateLabel.isHidden = true
        newRateLabel.isHidden = true
        nonImageView.isHidden = true
        blowUpImageView.isHidden = false
        rateLabel.isHidden = true
        increaseRateImageView.isHidden = true
        decreaseRateImageView.isHidden = true
    }
}

// MARK: - Update
public extension ChartContentTableViewCell {
    func update(model: ChartRankingEntity, index: Int, type: ChartDateType) {
        self.model = model
        self.backgroundColor = model.isSelected ? DesignSystemAsset.BlueGrayColor.gray200.color : .clear

        let lastRanking = model.last - (index + 1)
        albumImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        titleStringLabel.attributedText = getAttributedString(
            text: model.title,
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        )
        groupStringLabel.attributedText = getAttributedString(
            text: model.artist,
            font: DesignSystemFontFamily.Pretendard.light.font(size: 12)
        )
        if type == .total {
            hitsLabel.attributedText = getAttributedString(
                text: model.views.addCommaToNumber() + "회",
                font: DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
            )
        } else {
            hitsLabel.attributedText = getAttributedString(
                text: model.increase.addCommaToNumber() + "회",
                font: DesignSystemFontFamily.SCoreDream._3Light.font(size: 12)
            )
        }
        rankingLabel.attributedText = getAttributedString(
            text: "\(index + 1)",
            font: DesignSystemFontFamily.Pretendard.medium.font(size: 16)
        )

        if model.last == 0 {
            newThenBefore()
            return()
        } else if lastRanking > 99 {
            blowThenBefore()
            return()
        } else if lastRanking == 0 {
            sameAsBefore()
            return()
        } else if lastRanking > 0 {
            higherThanBefore(ranking: lastRanking)
            return()
        } else if lastRanking < 0 {
            lowerThanBefore(ranking: lastRanking)
            return()
        }
    }
}

private extension ChartContentTableViewCell {
    func getAttributedString(
        text: String,
        font: UIFont
    ) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: DesignSystemAsset.BlueGrayColor.gray900.color,
                .kern: -0.5
            ]
        )
        return attributedString
    }

    @objc func thumbnailToPlayButtonAction() {
        guard let song = self.model else { return }
        delegate?.tappedThumbnail(id: song.id)
    }
}
