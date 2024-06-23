import Foundation
import UIKit

open class VerticalAlignButton: UIButton {
    public private(set) var spacing: CGFloat

    public init(
        title: String? = nil,
        image: UIImage? = nil,
        spacing: CGFloat = 0.0
    ) {
        self.spacing = spacing
        super.init(frame: .zero)

        var config = UIButton.Configuration.plain()
        config.imagePlacement = .top
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var attribute = $0
            attribute.font = UIFont.setFont(.t7(weight: .medium))
            attribute.foregroundColor = DesignSystemAsset.NewGrayColor.gray400.color
            attribute.kern = -0.5
            return attribute
        }
        config.title = title
        config.image = image
        config.contentInsets = .zero
        self.configuration = config
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.contentHorizontalAlignment = .left
    }
}
