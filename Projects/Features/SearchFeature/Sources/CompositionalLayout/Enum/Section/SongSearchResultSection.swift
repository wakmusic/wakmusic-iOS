import Foundation

internal enum SongSearchResultSection: Int {
    case song = 0

    var title: String {
        switch self {
        case .song:
            "노래"
        }
    }
}
