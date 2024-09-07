import Foundation
import UIKit

open class HorizontalAlignButton: UIButton {
    public init(
        imagePlacement: NSDirectionalRectEdge,
        title: String? = nil,
        image: UIImage? = nil,
        font: UIFont,
        titleColor: UIColor,
        spacing: CGFloat = 0.0
    ) {
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.imagePlacement = imagePlacement
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var attribute = $0
            attribute.font = font
            attribute.foregroundColor = titleColor
            attribute.kern = -0.5
            return attribute
        }
        config.title = title
        config.image = image
        config.imagePadding = spacing
        self.configuration = config
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
    }
}
