import DataMappingModule
import DomainModule
import Utility


public extension AddSongResponseDTO {
    func toDomain() -> AddSongEntity {
        AddSongEntity(status: status,
                      added_songs_length: added_songs_length,
                      duplicated: duplicated
        )
    }
}
