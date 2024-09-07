import DesignSystem
import UIKit

final class PlaylistActivity: UIActivity {
    override var activityType: UIActivity.ActivityType {
        return UIActivity.ActivityType("com.wakmu.playlist.share.activity")
    }

    override var activityTitle: String? {
        return "플레이리스트 공유하기"
    }

    override var activityImage: UIImage? {
        return DesignSystemAsset.Logo.applogo.image
    }
}
