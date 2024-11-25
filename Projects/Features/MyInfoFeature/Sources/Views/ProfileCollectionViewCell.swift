import DesignSystem
import ImageDomainInterface
import UIKit
import Utility

public class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var outerView: UIView!

    override public func awakeFromNib() {
        super.awakeFromNib()
        Task { @MainActor in
            clipsToBounds = false
            contentView.clipsToBounds = false
        }
    }
}

public extension ProfileCollectionViewCell {
    func update(_ model: ProfileListEntity) {
        imageView.layer.cornerRadius = ((APP_WIDTH() - 70) / 4) / 2
        imageView.kf.setImage(
            with: URL(string: model.url),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )

        outerView.layer.cornerRadius = imageView.layer.cornerRadius + 2
        outerView.layer.borderColor = model.isSelected ?
            DesignSystemAsset.PrimaryColor.point.color.cgColor :
            UIColor.clear.cgColor
        outerView.layer.borderWidth = 2
        outerView.clipsToBounds = false
    }
}
