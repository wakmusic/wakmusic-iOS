import DesignSystem
import FaqDomainInterface
import UIKit

final class FAQAnswerTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        if Thread.isMainThread {
            MainActor.assumeIsolated {
                answerLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
                answerLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 6)
            }
        } else {
            Task { @MainActor in
                answerLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
                answerLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 6)
            }
        }
    }
}

extension FAQAnswerTableViewCell {
    public func update(model: FaqEntity) {
        answerLabel.text = model.answer
    }
}
