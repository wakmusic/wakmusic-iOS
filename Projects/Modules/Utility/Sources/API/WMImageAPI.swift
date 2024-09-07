import Foundation

public enum WMImageAPI {
    case fetchYoutubeThumbnail(id: String)
    case fetchYoutubeThumbnailHD(id: String)
}

public extension WMImageAPI {
    var baseURLString: String {
        return "https://i.ytimg.com"
    }

    var path: String {
        switch self {
        case let .fetchYoutubeThumbnail(id):
            return "vi/\(id)/mqdefault.jpg"

        case let .fetchYoutubeThumbnailHD(id):
            return "vi/\(id)/maxresdefault.jpg"
        }
    }

    var toString: String {
        switch self {
        case .fetchYoutubeThumbnail, .fetchYoutubeThumbnailHD:
            return baseURLString + "/" + path
        }
    }

    var toURL: URL? {
        switch self {
        case .fetchYoutubeThumbnail, .fetchYoutubeThumbnailHD:
            return URL(string: baseURLString + "/" + path)
        }
    }
}
