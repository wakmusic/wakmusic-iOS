import Foundation
import SongsDomainInterface

public struct WmPlaylistDetailEntity: Equatable {
    public init(
        key: String,
        title: String,
        songs: [SongEntity],
        image: String
    ) {
        self.key = key
        self.title = title
        self.songs = songs
        self.image = image
    }

    public let key, title, image: String
    public var songs: [SongEntity]
}
