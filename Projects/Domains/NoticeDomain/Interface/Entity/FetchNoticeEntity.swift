import Foundation

public struct FetchNoticeEntity {
    public init(
        id: Int,
        category: String,
        title: String,
        content: String,
        thumbnail: FetchNoticeEntity.Image,
        origins: [FetchNoticeEntity.Image],
        createdAt: Double
    ) {
        self.id = id
        self.category = category
        self.title = title
        self.content = content
        self.thumbnail = thumbnail
        self.origins = origins
        self.createdAt = createdAt
    }

    public let id: Int
    public let category, title: String
    public let content: String
    public let thumbnail: FetchNoticeEntity.Image
    public let origins: [FetchNoticeEntity.Image]
    public let createdAt: Double
    public var isRead: Bool = true
}

public extension FetchNoticeEntity {
    struct Image {
        public init (
            url: String,
            link: String
        ) {
            self.url = url
            self.link = link
        }

        public let url: String
        public let link: String
    }
}
