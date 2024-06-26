import Foundation
import SongsDomainInterface

public struct PlaylistDetailEntity: Equatable {
    public init(
        key: String,
        title: String,
        songs: [SongEntity],
        image: String,
        `private`: Bool

    ) {
        self.key = key
        self.title = title
        self.songs = songs
        self.image = image
        self.private = `private`
    }

    public let key, title: String
    public var songs: [SongEntity]
    public let image: String
    public var `private`: Bool
}
