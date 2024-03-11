import Foundation
import PlayListDomainInterface

public struct AddSongResponseDTO: Decodable {
    public let status: Int
    public let addedSongsLength: Int
    public let duplicated: Bool
}

public extension AddSongResponseDTO {
    func toDomain() -> AddSongEntity {
        AddSongEntity(
            status: status,
            added_songs_length: addedSongsLength,
            duplicated: duplicated,
            description: ""
        )
    }
}
