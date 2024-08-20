import Foundation

public enum PlaylistFloatingButtonPosition {
    case `default`
    case top

    public var bottomOffset: CGFloat {
        switch self {
        case .default:
            return -20
        case .top:
            return -80
        }
    }
}
