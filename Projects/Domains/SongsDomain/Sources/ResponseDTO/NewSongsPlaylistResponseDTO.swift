import Foundation
import SongsDomainInterface

struct NewSongsPlaylistResponseDTO: Decodable {
    let url: String

    enum CodingKeys: String, CodingKey {
        case url = "data"
    }
}

extension NewSongsPlaylistResponseDTO {
    func toDomain() -> NewSongsPlaylistEntity {
        return NewSongsPlaylistEntity(url: url)
    }
}
