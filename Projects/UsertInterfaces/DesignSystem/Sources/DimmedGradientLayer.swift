import UIKit

open class DimmedGradientLayer: CAGradientLayer {
    public init(frame: CGRect) {
        super.init()
        self.frame = frame
        self.colors = [
            DesignSystemAsset.NewGrayColor.gray900.color.withAlphaComponent(0.6).cgColor,
            DesignSystemAsset.NewGrayColor.gray900.color.withAlphaComponent(1.0).cgColor
        ]
        self.startPoint = .init(x: 0.5, y: 0.4)
        self.endPoint = .init(x: 0.5, y: 1.0)
        self.opacity = 1.0
    }

    @available(*, unavailable)
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
