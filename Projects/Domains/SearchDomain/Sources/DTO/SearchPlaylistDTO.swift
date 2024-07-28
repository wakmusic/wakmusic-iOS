import Foundation
import SearchDomainInterface
import Utility

public struct SearchPlaylistDTO: Decodable {
    public init(
        key: String,
        title: String,
        user: User,
        imageUrl: String,
        songCount: Int,
        shareCount: Int,
        createdAt: Double,
        `private`: Bool
    ) {
        self.key = key
        self.title = title
        self.user = user
        self.imageUrl = imageUrl
        self.songCount = songCount
        self.shareCount = shareCount
        self.createdAt = createdAt
        self.private = `private`
    }

    public struct User: Decodable {
        let handle: String
        let name: String
    }

    public let key, title, imageUrl: String
    public let user: User
    public let `private`: Bool
    public let songCount, shareCount: Int
    public let createdAt: Double

    enum CodingKeys: String, CodingKey {
        case shareCount = "subscribeCount"
        case key = "key"
        case title = "title"
        case imageUrl = "imageUrl"
        case user = "user"
        case `private` = "private"
        case songCount = "songCount"
        case createdAt = "createdAt"
    }
}

public extension SearchPlaylistDTO {
    func toDomain() -> SearchPlaylistEntity {
        SearchPlaylistEntity(
            key: key,
            title: title,
            ownerId: user.handle,
            userName: user.name,
            image: imageUrl,
            date: (createdAt / 1000.0).unixTimeToDate.dateToString(format: "yyyy.MM.dd"),
            count: songCount,
            shareCount: shareCount,
            isPrivate: self.`private`
        )
    }
}
