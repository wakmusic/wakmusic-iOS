import Foundation

internal enum IntegratedSearchResultSection: Int {
    case song = 0
    case list

    var title: String {
        switch self {
        case .song:
            "노래"
        case .list:
            "리스트"
        }
    }
}
