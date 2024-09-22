import Foundation
import SongsDomainInterface

public struct PlaylistItem: Equatable, Hashable {
    public let id: String
    public let title: String
    public let artist: String

    public init(
        id: String,
        title: String,
        artist: String
    ) {
        self.id = id
        self.title = title
        self.artist = artist
    }

    public init(item: SongEntity) {
        self.id = item.id
        self.title = item.title
        self.artist = item.artist
    }
}
