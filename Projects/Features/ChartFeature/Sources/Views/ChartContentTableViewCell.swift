import UIKit
import SnapKit
import Then
import DesignSystem

public final class ChartContentTableViewCell: UITableViewCell {
    private let increaseRateImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    private let increaseRateLabel = UILabel().then {
        $0.font = DesignSystemFontFamily.Pretendard.medium.font(size: 11)
    }
    private let albumImageView = UIImageView().then {
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
        $0.textColor = DesignSystemAsset.GrayColor.gray900.color
        $0.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
    }

    public override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        addView()
        setLayout()
    }
}

extension ChartContentTableViewCell {
    private func addView() {
        [
            increaseRateImageView,
            increaseRateLabel,
            albumImageView,
            hitsLabel,
            titleStringLabel,
            groupStringLabel
        ].forEach {
            contentView.addSubview($0)
        }
    }
    private func setLayout() {
        albumImageView.snp.makeConstraints {
            $0.width.equalTo(72)
            $0.height.equalTo(40)
            $0.leading.equalTo(53)
            $0.centerY.equalTo(contentView)
        }
        hitsLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.centerY.equalTo(contentView)
            $0.trailing.equalTo(-20)
        }
        titleStringLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(9)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(hitsLabel.snp.left).inset(8)
        }
        groupStringLabel.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.bottom.equalTo(-9)
            $0.leading.equalTo(albumImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(hitsLabel.snp.left).inset(8)
        }
    }
}
