import DesignSystem
import UIKit

enum KaraokeKind {
    case KY
    case TJ

    var koreanTitle: String {
        switch self {
        case .KY:
            "금영"
        case .TJ:
            "태진"
        }
    }

    var logoImage: UIImage {
        switch self {
        case .KY:
            return DesignSystemAsset.MusicDetail.ky.image
        case .TJ:
            return DesignSystemAsset.MusicDetail.tj.image
        }
    }
}
