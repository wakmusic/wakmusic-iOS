import DesignSystem
import UIKit
import Utility

protocol RecentRecordDelegate: AnyObject {
    func selectedItems(_ keyword: String)
}

final class RecentRecordTableViewCell: UITableViewCell {
    private let recentLabel = WMLabel(
        text: "",
        textColor: DesignSystemAsset.NewGrayColor.gray900.color,
        font: .t6(weight: .medium),
        alignment: .left,
        lineHeight: UIFont.WMFontSystem.t6().lineHeight,
        kernValue: -0.5
    ).then {
        $0.numberOfLines = 1
    }

    private let button: UIButton = UIButton().then {
        $0.setImage(DesignSystemAsset.Search.keywordRemove.image, for: .normal)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubviews(recentLabel, button)

        recentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        button.snp.makeConstraints {
            $0.width.height.equalTo(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.centerY.equalToSuperview()
        }

        button.addAction {
            PreferenceManager.shared.removeRecentRecords(word: self.recentLabel.text!)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecentRecordTableViewCell {
    public func update(_ text: String) {
        recentLabel.text = text
    }
}
