import DesignSystem
import FaqDomainInterface
import UIKit

class AnswerTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        answerLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 14)
        answerLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 6)
    }
}

extension AnswerTableViewCell {
    public func update(model: FaqEntity) {
        answerLabel.text = model.answer
    }
}
