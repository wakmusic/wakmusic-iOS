import UIKit
import SnapKit
import Then
import DesignSystem
import DomainModule
import Kingfisher
import Utility

public final class ChartContentTableViewCell: UITableViewCell {
    // MARK: - UI
    private let rankingLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    }
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
    private let newRateLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.PrimaryColor.new.color
        $0.text = "NEW"
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 11)
    }
    private let rateLabel = UILabel().then {
        $0.textAlignment = .center
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 11)
    }
    private let albumImageView = UIImageView().then {
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4
        $0.contentMode = .scaleAspectFill
    }
    private let titleStringLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
    }
    private let groupStringLabel = UILabel().then {
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
    }
    private let hitsLabel = UILabel().then {
        $0.textAlignment = .right
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
    }

    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addView()
        setRankingLayout()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func prepareForReuse() {
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
extension ChartContentTableViewCell {
    private func addView() {
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
            groupStringLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    private func setRankingLayout() {
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
    private func setLayout() {
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
    }
}

// MARK: - Chart 등락률 화살표
extension ChartContentTableViewCell {
    private func newThenBefore() {
        newRateLabel.isHidden = false
        nonImageView.isHidden = true
        blowUpImageView.isHidden = true
        increaseRateImageView.isHidden = true
        decreaseRateImageView.isHidden = true
        rateLabel.isHidden = true
    }
    private func higherThanBefore(ranking: Int) {
        rateLabel.textColor = DesignSystemAsset.PrimaryColor.increase.color
        rateLabel.text = "\(ranking)"
        rateLabel.isHidden = false
        newRateLabel.isHidden = true
        nonImageView.isHidden = true
        blowUpImageView.isHidden = true
        increaseRateImageView.isHidden = false
        decreaseRateImageView.isHidden = true
    }
    private func lowerThanBefore(ranking: Int) {
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
    private func sameAsBefore() {
        rateLabel.isHidden = true
        newRateLabel.isHidden = true
        nonImageView.isHidden = false
        blowUpImageView.isHidden = true
        rateLabel.isHidden = true
        increaseRateImageView.isHidden = true
        decreaseRateImageView.isHidden = true
    }
    private func blowThenBefore() {
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
extension ChartContentTableViewCell {
    public func update(model: ChartRankingEntity, index: Int) {
        
        self.backgroundColor = model.isSelected ? DesignSystemAsset.GrayColor.gray200.color : .clear
        
        let lastRanking = model.last - (index + 1)
        albumImageView.kf.setImage(
            with: URL(string: WMImageAPI.fetchYoutubeThumbnail(id: model.id).toString),
            placeholder: DesignSystemAsset.Logo.placeHolderSmall.image,
            options: [.transition(.fade(0.2))]
        )
        titleStringLabel.text = model.title
        groupStringLabel.text = model.artist
        hitsLabel.text = model.views.addCommaToNumber() + "회"
        rankingLabel.text = "\(index + 1)"
        
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
