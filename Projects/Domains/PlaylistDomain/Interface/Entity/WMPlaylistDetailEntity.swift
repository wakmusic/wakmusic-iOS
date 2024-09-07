import Foundation
import SongsDomainInterface

public struct WMPlaylistDetailEntity: Equatable {
    public init(
        key: String,
        title: String,
        songs: [SongEntity],
        image: String,
        playlistURL: String
    ) {
        self.key = key
        self.title = title
        self.songs = songs
        self.image = image
        self.playlistURL = playlistURL
    }

    public let key, title, image, playlistURL: String
    public var songs: [SongEntity]
}
