import Foundation
import SongsDomainInterface

public struct FavoriteSongEntity: Equatable {
    public init(songID: String, title: String, artist: String, like: Int) {
        self.songID = songID
        self.title = title
        self.artist = artist
        self.like = like
        self.isSelected = false
    }

    public let songID: String
    public let title: String
    public let artist: String
    public let like: Int
    #warning("엔티티에 기반한 상태관리 로직 리팩토링")
    public var isSelected: Bool
}
