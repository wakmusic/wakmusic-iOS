import Foundation

internal enum ListSearchResultSection: Int {
    case list = 1

    var title: String {
        switch self {
        case .list:
            "노래"
        }
    }
}
