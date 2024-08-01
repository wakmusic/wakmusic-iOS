import DesignSystem
import Foundation
import UIKit

final class MusicHeartButton: VerticalAlignButton {
    private(set) var isLike: Bool = false

    init() {
        super.init()

        let heartImage = DesignSystemAsset.MusicDetail.heart.image
        self.setTitle("0", for: .normal)
        self.titleLabel?.font = .setFont(.t7(weight: .medium))
        self.setImage(heartImage, for: .normal)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setIsLike(isLike: Bool, animated: Bool = true) {
        let heartImage: UIImage
        if isLike {
            heartImage = DesignSystemAsset.MusicDetail.heartFill.image
        } else {
            heartImage = DesignSystemAsset.MusicDetail.heart.image
        }

        self.isLike = isLike
        guard animated else {
            self.setImage(heartImage, for: .normal)
            self.setIsLikeTextColor(isLike: isLike)
            return
        }

        self.imageView?.transform = .init(scaleX: 1.25, y: 1.25)
        UIViewPropertyAnimator(duration: 0.3, curve: .easeIn) {
            self.imageView?.transform = .identity
        }
        .startAnimation()

        self.setImage(heartImage, for: .normal)
        self.setIsLikeTextColor(isLike: isLike)
    }

    private func setIsLikeTextColor(isLike: Bool) {
        if isLike {
            self.setTextColor(color: DesignSystemAsset.PrimaryColorV2.increase.color)
        } else {
            self.setTextColor(color: DesignSystemAsset.NewGrayColor.gray400.color)
        }
    }
}
