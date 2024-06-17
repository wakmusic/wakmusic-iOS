import Foundation

public struct FetchNoticeModel {
    public init(
        id: Int,
        category: String,
        title: String,
        content: String,
        thumbnail: FetchNoticeModel.Image,
        origins: [FetchNoticeModel.Image],
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
    public let thumbnail: FetchNoticeModel.Image
    public let origins: [FetchNoticeModel.Image]
    public let createdAt: Double
}

public extension FetchNoticeModel {
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
