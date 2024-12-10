import DesignSystem
import NoticeDomainInterface
import UIKit
import Utility

class NoticeListCell: UITableViewCell {
    @IBOutlet weak var titleStringLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            self.backgroundColor = .clear
            self.contentView.backgroundColor = .clear

            titleStringLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
            titleStringLabel.textColor = DesignSystemAsset.BlueGrayColor.blueGray900.color
            titleStringLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 1.26)

            dayLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            dayLabel.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
            dayLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 0)

            timeLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
            timeLabel.textColor = DesignSystemAsset.BlueGrayColor.blueGray500.color
            timeLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 0, lineHeightMultiple: 0)
        }
    }
}

extension NoticeListCell {
    func update(model: FetchNoticeEntity) {
        titleStringLabel.text = model.title
        dayLabel.text = (model.createdAt / 1000.0).unixTimeToDate.dateToString(format: "yy.MM.dd")
        timeLabel.text = (model.createdAt / 1000.0).unixTimeToDate.dateToString(format: "HH:mm")
    }

    func updateVisibleIndicator(visible: Bool) {
        if visible {
            let attributedString = NSMutableAttributedString(string: titleStringLabel.text ?? "")
            let padding = NSTextAttachment()
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = DesignSystemAsset.MyInfo.redDot.image
            imageAttachment.bounds = CGRect(x: 0, y: 10, width: 5, height: 5)
            padding.bounds = CGRect(x: 0, y: 0, width: 2, height: 0)

            attributedString.append(NSAttributedString(attachment: padding))
            attributedString.append(NSAttributedString(attachment: imageAttachment))
            titleStringLabel.attributedText = attributedString
        } else {
            guard let attributedText = titleStringLabel.attributedText else { return }
            let text = attributedText.string
            titleStringLabel.attributedText = nil
            titleStringLabel.text = text
        }
    }
}
