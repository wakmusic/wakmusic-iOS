import Foundation
import SongsDomainInterface

public struct PlaylistDetailEntity: Equatable {
    public init(
        key: String,
        title: String,
        songs: [SongEntity],
        image: String,
        `private`: Bool,
        userId: String,
        userName: String

    ) {
        self.key = key
        self.title = title
        self.songs = songs
        self.image = image
        self.private = `private`
        self.userId = userId
        self.userName = userName
    }

    public let key, title: String
    public var songs: [SongEntity]
    public let image, userId, userName: String
    public var `private`: Bool
}
