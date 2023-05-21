import DataMappingModule
import DomainModule
import Utility


public extension FavoriteSongsResponseDTO {
    func toDomain() -> FavoriteSongEntity {
        FavoriteSongEntity(
            likes: likes,
            song: song.toDomain(),
            isSelected: false
        )
    }
}
