import DesignSystem
import FaqDomainInterface
import UIKit

final class FAQQuestionTableViewCell: UITableViewCell {
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expandImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        if Thread.isMainThread {
            MainActor.assumeIsolated {
                categoryLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
                categoryLabel.setTextWithAttributes(kernValue: -0.5)
                titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
                titleLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 5)
            }
        } else {
            Task { @MainActor in
                categoryLabel.font = DesignSystemFontFamily.Pretendard.light.font(size: 12)
                categoryLabel.setTextWithAttributes(kernValue: -0.5)
                titleLabel.font = DesignSystemFontFamily.Pretendard.medium.font(size: 16)
                titleLabel.setTextWithAttributes(kernValue: -0.5, lineSpacing: 5)
            }
        }
    }
}

extension FAQQuestionTableViewCell {
    func update(model: FaqEntity) {
        categoryLabel.text = model.category
        titleLabel.text = model.question
        expandImageView.image = model.isOpen ? DesignSystemAsset.Navigation.fold.image : DesignSystemAsset.Navigation
            .close.image
    }
}
