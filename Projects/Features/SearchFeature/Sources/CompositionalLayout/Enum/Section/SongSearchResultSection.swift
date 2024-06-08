import Foundation

internal enum SongSearchResultSection: Hashable {
    case song

    var title: String {
        switch self {
        case .song:
            "노래"
        }
    }
}
