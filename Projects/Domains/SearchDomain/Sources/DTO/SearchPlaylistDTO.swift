import Foundation
import SearchDomainInterface
import Utility

#warning("서버에서 username nullable빠지면 옵셔널 제거하기")
public struct SearchPlaylistDTO: Decodable {
    public init(
        key: String,
        title: String,
        userName: String?,
        imageUrl: String,
        songCount: Int,
        createdAt: Double,
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

    public let key, title, imageUrl: String
    public let userName: String?
    public let `private`: Bool
    public let songCount: Int
    public let createdAt: Double
}

public extension SearchPlaylistDTO {
    func toDomain() -> SearchPlaylistEntity {
        SearchPlaylistEntity(
            key: key,
            title: title,
            userName: userName ?? "임시 닉네임",
            image: imageUrl,
            date: (createdAt/1000.0).unixTimeToDate.dateToString(format: "yyyy.MM.dd"),
            count: songCount,
            isPrivate: self.`private`
        )
    }
}
