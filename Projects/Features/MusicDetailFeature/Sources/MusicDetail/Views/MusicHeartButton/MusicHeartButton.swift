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
        let heartImage: UIImage = if isLike {
            DesignSystemAsset.MusicDetail.heartFill.image
        } else {
            DesignSystemAsset.MusicDetail.heart.image
        }

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
