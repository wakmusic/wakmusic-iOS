import Foundation
import SongsDomainInterface

struct CreditSongModel: Equatable, Hashable {
    let id: String
    let title: String
    let artist: String
    let date: String

    init(songEntity: SongEntity) {
        self.id = songEntity.id
        self.title = songEntity.title
        self.artist = songEntity.artist
        self.date = songEntity.date
    }
}
