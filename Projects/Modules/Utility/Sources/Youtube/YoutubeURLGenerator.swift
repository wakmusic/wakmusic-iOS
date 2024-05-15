import Foundation

public protocol YoutubeURLGeneratable {
    func generateThumbnailURL(id: String) -> String
    func generateHDThumbnailURL(id: String) -> String
    func generateYoutubeVideoAppURL(id: String) -> String
    func generateYoutubeVideoWebURL(id: String) -> String
}

public struct YoutubeURLGenerator: YoutubeURLGeneratable {
    public init() {}

    public func generateThumbnailURL(id: String) -> String {
        "https://i.ytimg.com/vi/\(id)/mqdefault.jpg"
    }

    public func generateHDThumbnailURL(id: String) -> String {
        "https://i.ytimg.com/vi/\(id)/maxresdefault.jpg"
    }

    public func generateYoutubeVideoAppURL(id: String) -> String {
        "youtube://\(id)"
    }

    public func generateYoutubeVideoWebURL(id: String) -> String {
        "https://youtube.com/watch?v=\(id)"
    }
}
