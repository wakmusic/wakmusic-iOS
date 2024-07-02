import DesignSystem
import ImageDomainInterface
import UIKit
import Utility

public enum FanType: String {
    case panchi
    case ifari
    case dulgi
    case bat
    case segyun
    case gorani
    case jupock
    case ddong
}

public class ProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!

    override public func awakeFromNib() {
        super.awakeFromNib()
    }
}

public extension ProfileCollectionViewCell {
    func update(_ model: ProfileListEntity) {
        self.imageView.layer.cornerRadius = ((APP_WIDTH() - 70) / 4) / 2
        self.imageView.layer.borderColor = model.isSelected ? DesignSystemAsset.PrimaryColor.point.color
            .cgColor : UIColor.clear.cgColor
        self.imageView.layer.borderWidth = 3

        self.imageView.kf.setImage(
            with: URL(string: model.url),
            placeholder: nil,
            options: [.transition(.fade(0.2))]
        )
    }
}
