import DataMappingModule
import DomainModule
import Utility


public extension AddSongResponseDTO {
    func toDomain() -> AddSongEntity {
        AddSongEntity(status: status,
                      added_songs_length: addedSongsLength,
                      duplicated: duplicated,
                      description: ""
        )
    }
}
