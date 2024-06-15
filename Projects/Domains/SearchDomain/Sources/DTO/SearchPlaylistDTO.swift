import Foundation
import SearchDomainInterface
import Utility

public struct SearchPlaylistDTO: Decodable {
    public init(
        key: String,
        title: String,
        userName: String,
        imageUrl: String,
        songCount: Int,
        createdAt: Int,
        `private`: Bool
    ) {
        self.key = key
        self.title = title
        self.userName = userName
        self.imageUrl = imageUrl
        self.songCount = songCount
        self.createdAt = createdAt
        self.private = `private`
    }

    public let key, title, userName, imageUrl: String
    public let `private`: Bool
    public let songCount, createdAt: Int
}

public extension SearchPlaylistDTO {
    func toDomain() -> SearchPlaylistEntity {
        SearchPlaylistEntity(
            key: key,
            title: title,
            userName: userName,
            image: imageUrl,
            date: createdAt.changeDateFormat(origin: "yyMMdd", result: "yyyy.MM.dd"),
            count: songCount,
            isPrivate: self.`private`
        )
    }
}
