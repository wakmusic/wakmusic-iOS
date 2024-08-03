import Foundation
import UIKit
import Utility

extension Double {
    var correctLeading: CGFloat {
        return self * APP_WIDTH() / 375.0
    }

    var correctTrailing: CGFloat {
        return -self * APP_WIDTH() / 375.0
    }

    var correctTop: CGFloat {
        return APP_HEIGHT() * (self / 812.0)
    }

    var correctBottom: CGFloat {
        return -APP_HEIGHT() * (self / 812.0)
    }
}
