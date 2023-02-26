import UIKit
import SnapKit
import Then
import DesignSystem
import DomainModule
import Kingfisher
import Utility

public final class ChartContentTableViewCell: UITableViewCell {
    private let rankingLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
    }
    private let onlyincreaseRateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let increaseRateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let increaseRateLabel = UILabel().then {
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addView()
        setLayout()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(model: ChartRankingEntity, index: Int) {
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
        print("----------\nrankingLabel.text : \(index + 1)\nlastRanking : \(lastRanking)")
        if lastRanking > 99 {
            blowThenBefore()
            print("blowThenBefore 실행\n----------")
            return()
        }
        else if lastRanking == 0 {
            higherThanBefore(ranking: lastRanking)
            print("higherThanBefore 실행\n----------")
            return()
        }
        else if lastRanking > 0 {
            sameAsBefore()
            print("sameAsBefore 실행\n----------")
            return()
        }
        else if lastRanking < 0 {
            lowerThanBefore(ranking: lastRanking)
            print("lowerThanBefore 실행\n----------")
            return()
        }
    }
}

extension ChartContentTableViewCell {
    private func addView() {
        [
            rankingLabel,
//            onlyincreaseRateImageView,
//            increaseRateImageView,
//            increaseRateLabel,
            albumImageView,
            hitsLabel,
            titleStringLabel,
            groupStringLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    private func setLayout() {
        rankingLabel.snp.makeConstraints {
            $0.top.equalTo(10)
            $0.left.equalTo(20)
            $0.width.equalTo(28)
            $0.height.equalTo(24)
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
    private func higherThanBefore(ranking: Int) {
        increaseRateImageView.image = DesignSystemAsset.Chart.down.image
        increaseRateLabel.textColor = DesignSystemAsset.PrimaryColor.increase.color
        increaseRateLabel.text = "\(ranking)"

        contentView.addSubview(increaseRateImageView)
        contentView.addSubview(increaseRateLabel)
        increaseRateImageView.snp.remakeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom).offset(2)
            $0.width.height.equalTo(12)
            $0.left.equalTo(21)
        }
        increaseRateLabel.snp.makeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom)
            $0.height.equalTo(16)
            $0.width.equalTo(14)
            $0.left.equalTo(33)
        }
    }
    private func sameAsBefore() {
        increaseRateImageView.image = DesignSystemAsset.Chart.non.image

        contentView.addSubview(increaseRateImageView)
        increaseRateImageView.snp.remakeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom).offset(2)
            $0.width.height.equalTo(12)
            $0.left.equalTo(28)
        }
    }
    private func lowerThanBefore(ranking: Int) {
        let minusBeforeRanking = "\(ranking)"
        increaseRateImageView.image = DesignSystemAsset.Chart.down.image
        increaseRateLabel.textColor = DesignSystemAsset.PrimaryColor.decrease.color
        increaseRateLabel.text = minusBeforeRanking.trimmingCharacters(in: ["-"])

        contentView.addSubview(increaseRateImageView)
        contentView.addSubview(increaseRateLabel)
        increaseRateImageView.snp.remakeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom).offset(2)
            $0.width.height.equalTo(12)
            $0.left.equalTo(21)
        }
        increaseRateLabel.snp.remakeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom)
            $0.height.equalTo(16)
            $0.width.equalTo(14)
            $0.left.equalTo(33)
        }

    }
    private func blowThenBefore() {
        increaseRateImageView.image = DesignSystemAsset.Chart.blowup.image

        contentView.addSubview(increaseRateImageView)
        increaseRateImageView.snp.remakeConstraints {
            $0.top.equalTo(rankingLabel.snp.bottom).offset(2)
            $0.width.height.equalTo(12)
            $0.left.equalTo(28)
        }
    }
}
