import DesignSystem
import UIKit

final class PlayMusicButtonGradientLayer: CAGradientLayer {
    init(frame: CGRect, cornerRadius: CGFloat) {
        super.init()
        self.frame = frame
        self.colors = [
            DesignSystemAsset.NewGrayColor.gray600.color.withAlphaComponent(0.0).cgColor,
            DesignSystemAsset.NewGrayColor.gray600.color.withAlphaComponent(1.0).cgColor
        ]
        self.startPoint = .init(x: 0.5, y: 0.4)
        self.endPoint = .init(x: 0.5, y: 1.0)
        self.cornerRadius = cornerRadius
        self.opacity = 0.5
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
