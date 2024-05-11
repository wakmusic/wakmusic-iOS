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
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.imagePlacement = .top
            config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                var attribute = $0
                attribute.font = UIFont.setFont(.t7(weight: .medium))
                attribute.foregroundColor = DesignSystemAsset.NewGrayColor.gray400.color
                return attribute
            }
            config.title = title
            config.image = image
            config.contentInsets = .zero
            self.configuration = config
        } else {
            self.setTitle(title, for: .normal)
            self.setTitleColor(DesignSystemAsset.NewGrayColor.gray400.color, for: .normal)
            self.setTitleColor(DesignSystemAsset.NewGrayColor.gray400.color, for: .selected)
            self.setTitleColor(DesignSystemAsset.NewGrayColor.gray400.color, for: .highlighted)
            self.setTitleColor(DesignSystemAsset.NewGrayColor.gray400.color, for: .disabled)
            self.titleLabel?.font = .setFont(.t7(weight: .medium))
            self.setImage(image, for: .normal)
        }
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.contentHorizontalAlignment = .left
    }

    private func alignButtonImageAndTitle() {
        if #available(iOS 15.0, *) {
        } else {
            let titleSize = self.titleLabel?.frame.size ?? .zero
            let imageSize = self.imageView?.frame.size ?? .zero

            self.imageEdgeInsets = UIEdgeInsets(
                top: -(titleSize.height + spacing),
                left: 0,
                bottom: 0,
                right: -titleSize.width
            )
            self.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -imageSize.width,
                bottom: -(imageSize.height + spacing),
                right: 0
            )
        }
    }
}
