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
        var config = self.configuration
        config?.baseForegroundColor = color

        config?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer {
            var attribute = $0
            attribute.font = font
            attribute.foregroundColor = color
            return attribute
        }
        self.configuration = config
    }

    func setSpacing(_ spacing: CGFloat) {
        if var config = self.configuration {
            config.imagePadding = spacing
            self.configuration = config
        }
    }
}
