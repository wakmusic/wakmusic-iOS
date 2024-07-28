import Foundation

public struct WMToastOptions: OptionSet {
    public let rawValue: Int
    public static let empty = WMToastOptions(rawValue: 1 << 0)
    public static let tabBar = WMToastOptions(rawValue: 1 << 1)
    public static let songCart = WMToastOptions(rawValue: 1 << 2)

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    var offset: CGFloat {
        switch self {
        case _ where self == [.empty]:
            return 56
        case _ where self == [.tabBar]:
            return 56 + 56
        case _ where self == [.songCart]:
            return 56 + 56
        case _ where self == [.tabBar, .songCart]:
            return 56 + 56 + 40
        default:
            return 56
        }
    }
}
