import Foundation
import UIKit

public extension Double {
    var unixTimeToDate: Date {
        return Date(timeIntervalSince1970: TimeInterval(truncating: NSNumber(value: self)))
    }

    var kilobytes: Double {
        return Double(self) / 1024
    }

    var megabytes: Double {
        return kilobytes / 1024
    }

    var gigabytes: Double {
        return megabytes / 1024
    }

    @MainActor
    var correctLeading: CGFloat {
        return self * APP_WIDTH() / 375.0
    }

    @MainActor
    var correctTrailing: CGFloat {
        return -self * APP_WIDTH() / 375.0
    }

    @MainActor
    var correctTop: CGFloat {
        return APP_HEIGHT() * (self / 812.0)
    }

    @MainActor
    var correctBottom: CGFloat {
        return -APP_HEIGHT() * (self / 812.0)
    }
}
