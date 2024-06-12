import Foundation

internal enum ListSearchResultSection: Hashable {
    case list

    var title: String {
        switch self {
        case .list:
            "노래"
        }
    }
}
