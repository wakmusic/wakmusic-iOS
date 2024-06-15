import Foundation
import SearchDomainInterface

public struct SearchPlaylistDTO: Decodable {
    public init(
        key: String,
        title: String,
        userName: String,
        imageUrl: String,
        songCount: Int,
        `private`: Bool

    ) {
        self.key = key
        self.title = title
        self.userName = userName
        self.imageUrl = imageUrl
        self.private = `private`
        self.songCount = songCount
    }

    public let key, title, userName, imageUrl: String
    public let `private`: Bool
    public let  songCount: Int
}

public extension SearchPlaylistDTO {
    func toDomain() -> SearchPlaylistEntity {
        SearchPlaylistEntity(
            key: key,
            title: title,
            userName: userName,
            image: imageUrl,
            count: songCount,
            private: self.`private`)
    }
}

