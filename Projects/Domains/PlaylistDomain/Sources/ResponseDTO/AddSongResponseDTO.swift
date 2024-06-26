import Foundation
import PlaylistDomainInterface

public struct AddSongResponseDTO: Decodable {
    public let addedSongCount: Int
    public let isDuplicatedSongsExist: Bool
}

public extension AddSongResponseDTO {
    func toDomain() -> AddSongEntity {
        AddSongEntity(
            addedSongCount: addedSongCount,
            duplicated: isDuplicatedSongsExist
        )
    }
}
