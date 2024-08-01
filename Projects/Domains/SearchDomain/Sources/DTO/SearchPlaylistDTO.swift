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
        subscribeCount: Int,
        createdAt: Double,
        `private`: Bool
    ) {
        self.key = key
        self.title = title
        self.user = user
        self.imageUrl = imageUrl
        self.songCount = songCount
        self.subscribeCount = subscribeCount
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
    public let songCount, subscribeCount: Int
    public let createdAt: Double
}

public extension SearchPlaylistDTO {
    func toDomain() -> SearchPlaylistEntity {
        SearchPlaylistEntity(
            key: key,
            title: title,
            ownerID: user.handle,
            userName: user.name,
            image: imageUrl,
            date: (createdAt / 1000.0).unixTimeToDate.dateToString(format: "yyyy.MM.dd"),
            count: songCount,
            subscribeCount: subscribeCount,
            isPrivate: self.`private`
        )
    }
}
