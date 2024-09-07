import Foundation

public enum ArtistSongSortType: Int {
    case new = 1
    case popular
    case old

    public var display: String {
        switch self {
        case .new:
            return "최신순"
        case .popular:
            return "인기순"
        case .old:
            return "과거순"
        }
    }
}
