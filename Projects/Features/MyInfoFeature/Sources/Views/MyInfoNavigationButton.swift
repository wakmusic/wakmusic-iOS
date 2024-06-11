import DesignSystem
import Foundation
import UIKit

final class MyInfoNavigationButton: VerticalAlignButton {
    init(title: String, image: UIImage, spacing: CGFloat = 8) {
        super.init(title: title, image: image, spacing: spacing)
        setTitle()
        setSpacing(spacing)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTitle(
        font: UIFont = .setFont(.t6(weight: .light)),
        color: UIColor = DesignSystemAsset.BlueGrayColor.blueGray600.color
    ) {
        if #available(iOS 15.0, *) {
            var config = self.configuration
            config?.baseForegroundColor = color

            config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
                var attribute = $0
                attribute.font = font
                attribute.foregroundColor = color
                return attribute
            }
            self.configuration = config
        } else {
            self.setTitleColor(color, for: .normal)
            self.titleLabel?.font = font
        }
    }

    func setSpacing(_ spacing: CGFloat) {
        if #available(iOS 15.0, *) {
            if var config = self.configuration {
                config.imagePadding = spacing
                self.configuration = config
            }
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
